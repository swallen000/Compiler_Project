.class public foo
.super java/lang/Object

.field public static _sc Ljava/util/Scanner;
.field public static a I
.field public static b I
.field public static c F

.method public static vinit()V
	.limit locals 100
	.limit stack 100
	ldc 0
	putstatic foo/a I
	ldc 0
	putstatic foo/b I
	ldc 0.0
	putstatic foo/c F
	return
.end method

.method public <init>()V
	aload_0
	invokenonvirtual java/lang/Object/<init>()V
	return
.end method

.method public static fact(I)I
	.limit locals 100
	.limit stack 100
	getstatic foo/b I
	getstatic foo/a I
	isub
	ifgt Ltrue_0
	iconst_0
	goto Lfalse_0
Ltrue_0:
	iconst_1
Lfalse_0:
	ifeq Lfalse_1
	ldc 111
	istore 1
	goto Lexit_1
Lfalse_1:
	ldc 222
	istore 1
Lexit_1:
	iload 1
	ireturn
.end method

.method public static main([Ljava/lang/String;)V
	.limit locals 100
	.limit stack 100
	invokestatic foo/vinit()V
	new java/util/Scanner
	dup
	getstatic java/lang/System/in Ljava/io/InputStream;
	invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V
	putstatic foo/_sc Ljava/util/Scanner;

	ldc 3
	invokestatic foo/fact(I)I
	putstatic foo/a I
	return
.end method

