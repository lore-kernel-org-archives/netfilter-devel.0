From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables compilation (or user :) error
Date: Wed, 10 Sep 2003 16:10:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5F30E5.9060402@trash.net>
References: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro> <Pine.LNX.4.51.0309101554140.6867@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gergely Imre <gimre@nextra.ro>,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0309101554140.6867@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The CLASSIFY target is already submitted to 2.6 and will be submitted to
2.4 soon, I believe.

Regards,
Patrick

Maciej Soltysiak wrote:

>>[root@imi userspace]# make
>>Making dependencies: please wait...
>>Something wrong... deleting dependencies.
>>make: *** [/usr/src/linux/include/linux/netfilter_ipv4/ipt_CLASSIFY.h]
>>Error 1
>>    
>>
>There is a bug in the build system, apply this patch over the
>netfilter tree.
>
>Harald, or anyone, can you apply this, it breaks all builds that did
>not choose CLASSIFY target to be patched from pom.
>
>ipt_CLASSIFY does not have a check and it is in the Makefile, although it
>is not a standard kernel module.
>
> .CLASSIFY-test |    2 ++
> Makefile       |    2 +-
> 2 files changed, 3 insertions(+), 1 deletion(-)
>
>Please use the attached (mime) patch in case you fail to apply this below.
>
>Regards,
>Maciej Soltysiak
>
>diff -Nru netfilter.orig/userspace/extensions/.CLASSIFY-test netfilter/userspace/extensions/.CLASSIFY-test
>--- netfilter.orig/userspace/extensions/.CLASSIFY-test	1970-01-01 01:00:00.000000000 +0100
>+++ netfilter/userspace/extensions/.CLASSIFY-test	2003-09-10 15:43:24.000000000 +0200
>@@ -0,0 +1,2 @@
>+#! /bin/sh
>+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CLASSIFY.c ] && echo CLASSIFY
>diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
>--- netfilter.orig/userspace/extensions/Makefile	2003-09-10 15:57:48.000000000 +0200
>+++ netfilter/userspace/extensions/Makefile	2003-09-10 15:44:09.000000000 +0200
>@@ -5,7 +5,7 @@
> # header files are present in the include/linux directory of this iptables
> # package (HW)
> #
>-PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
>+PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
> PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK
>
> # Optionals
>
>------------------------------------------------------------------------
>
>diff -Nru netfilter.orig/userspace/extensions/.CLASSIFY-test netfilter/userspace/extensions/.CLASSIFY-test
>--- netfilter.orig/userspace/extensions/.CLASSIFY-test	1970-01-01 01:00:00.000000000 +0100
>+++ netfilter/userspace/extensions/.CLASSIFY-test	2003-09-10 15:43:24.000000000 +0200
>@@ -0,0 +1,2 @@
>+#! /bin/sh
>+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CLASSIFY.c ] && echo CLASSIFY
>diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
>--- netfilter.orig/userspace/extensions/Makefile	2003-09-10 15:57:48.000000000 +0200
>+++ netfilter/userspace/extensions/Makefile	2003-09-10 15:44:09.000000000 +0200
>@@ -5,7 +5,7 @@
> # header files are present in the include/linux directory of this iptables
> # package (HW)
> #
>-PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
>+PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
> PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK
> 
> # Optionals
>  
>
