From: Pawel Sikora <pluto@pld-linux.org>
Subject: [PATCH] ipt_connlimit / speed-up.
Date: Thu, 21 Apr 2005 05:10:01 +0200
Message-ID: <200504210510.01886.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JmxZChiP/7q6dNC"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_JmxZChiP/7q6dNC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi All,

I've attached a small patch reduces register usage and redundant &0xff.

Regards,
Pawe=C5=82.

ipt_iphash: (original)
        movl    %eax, %ecx
        movzbl  %ah, %edx
        pushl   %ebx
        movl    %eax, %ebx
        shrl    $16, %ecx
        andl    $255, %eax
        xorl    %eax, %edx
        andl    $255, %ecx
        shrl    $24, %ebx
        xorl    %edx, %ecx
        xorl    %ecx, %ebx
        movl    %ebx, %eax
        popl    %ebx
        ret

ipt_iphash: (fixed)
        movl    %eax, %edx
        shrl    $8, %edx
        xorl    %eax, %edx
        shrl    $16, %eax
        xorl    %eax, %edx
        shrl    $8, %eax
        xorl    %eax, %edx
        movzbl  %dl,%eax
        ret

=2D-=20
/* Copyright (C) 2003, SCO, Inc. This is valuable Intellectual Property. */

                           #define say(x) lie(x)

--Boundary-00=_JmxZChiP/7q6dNC
Content-Type: text/x-diff;
  charset="utf-8";
  name="ipt_connlimit.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ipt_connlimit.diff"

Index: connlimit/linux-2.6.11/net/ipv4/netfilter/ipt_connlimit.c
===================================================================
--- connlimit/linux-2.6.11/net/ipv4/netfilter/ipt_connlimit.c	(revision 3884)
+++ connlimit/linux-2.6.11/net/ipv4/netfilter/ipt_connlimit.c	(working copy)
@@ -35,15 +35,13 @@
 	struct list_head iphash[256];
 };
 
-static int ipt_iphash(u_int32_t addr)
+static inline unsigned __attribute__((regparm(1), const))
+ipt_iphash(const unsigned addr)
 {
-	int hash;
-
-	hash  =  addr        & 0xff;
-	hash ^= (addr >>  8) & 0xff;
-	hash ^= (addr >> 16) & 0xff;
-	hash ^= (addr >> 24) & 0xff;
-	return hash;
+	return ((addr ^
+		(addr >>  8) ^
+		(addr >> 16) ^
+		(addr >> 24)) & 0xff);
 }
 
 static int count_them(struct ipt_connlimit_data *data,

--Boundary-00=_JmxZChiP/7q6dNC--
