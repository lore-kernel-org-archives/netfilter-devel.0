From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables 1.3.7 doesn't properly test for condition patch
Date: Tue, 29 May 2007 22:33:21 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705292230480.11140@yvahk01.tjqt.qr>
References: <bgel53lion8nqn77p455vughf1071fgple@4ax.com>
	<jb0o53l444mih7lnb29k4uba93jhsbfb3d@4ax.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailing List <netfilter@lists.netfilter.org>
To: Andrew Schulman <andrex@alumni.utexas.net>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <jb0o53l444mih7lnb29k4uba93jhsbfb3d@4ax.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


cc nf-dev

On May 29 2007 06:34, Andrew Schulman wrote:
>
>For the archive, Massimilano Hofer sent me the attached patch, which solves
>the problem.  It seems that this patch should be merged into iptables.
>
>Andrew.
>
>diff -Nru iptables-1.3.5-20060922.orig/extensions/.condition-test iptables-1.3.5-20060922.new/extensions/.condition-test
>--- iptables-1.3.5-20060922.orig/extensions/.condition-test	2002-11-02 16:00:15.000000000 +0100
>+++ iptables-1.3.5-20060922.new/extensions/.condition-test	2006-09-26 12:56:01.000000000 +0200
>@@ -1,3 +1,5 @@
> #!/bin/sh
> # True if condition is applied.
>-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && echo condition
>+( [ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] ||
>+  [ -f $KERNEL_DIR/include/linux/netfilter/xt_condition.h ] ) &&
>+ echo condition

While it is valid, why not use one '[ ]' test instead of two?

[ -f "$KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h" -o \
  -f "$KERNEL_DIR/include/linux/netfilter/xt_condition.h" ] && \
	echo condition;

Of course, the common prefix can be merged, i.e.:

S="$KERNEL_DIR/include/linux";
[ -f "$S/netfilter_ipv4/ipt_condition.h" -o "$S/netfilter/xt_condition.h" ] ...


	Jan
-- 
