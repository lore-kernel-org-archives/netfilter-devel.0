From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: HL target in the kernel
Date: Fri, 11 Apr 2003 16:45:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0304111641310.17096@dns.toxicfilms.tv>
References: <Pine.LNX.4.33.0304111030280.31394-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304111030280.31394-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> It seems to me there is dead code in the HL target. Could you fix it and
> resubmit the corrected patch?
Of course, here is a patch to the netfilter tree.

Regards,
Maciej Soltysiak


diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6 netfilter/patch-o-matic/base/HL.patch.ipv6
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6	2003-04-08 21:49:14.000000000 +0200
+++ netfilter/patch-o-matic/base/HL.patch.ipv6	2003-04-11 16:34:44.000000000 +0200
@@ -27,7 +27,7 @@
 diff -Nru linux-2.4.20/net/ipv6/netfilter/ip6t_HL.c linux.new/net/ipv6/netfilter/ip6t_HL.c
 --- linux-2.4.20/net/ipv6/netfilter/ip6t_HL.c	1970-01-01 01:00:00.000000000 +0100
 +++ linux.new/net/ipv6/netfilter/ip6t_HL.c	2002-12-16 17:08:23.000000000 +0100
-@@ -0,0 +1,105 @@
+@@ -0,0 +1,102 @@
 +/*
 + * Hop Limit modification target for ip6tables
 + * Maciej Soltysiak <solt@dns.toxicfilms.tv>
@@ -53,7 +53,6 @@
 +{
 +	struct ipv6hdr *ip6h = (*pskb)->nh.ipv6h;
 +	const struct ip6t_HL_info *info = targinfo;
-+	u_int16_t diffs[2];
 +	int new_hl;
 +
 +	switch (info->mode) {
@@ -76,9 +75,7 @@
 +	}
 +
 +	if (new_hl != ip6h->hop_limit) {
-+		diffs[0] = htons(((unsigned)ip6h->hop_limit) << 8) ^ 0xFFFF;
 +		ip6h->hop_limit = new_hl;
-+		diffs[1] = htons(((unsigned)ip6h->hop_limit) << 8);
 +	}
 +
 +	return IP6T_CONTINUE;
