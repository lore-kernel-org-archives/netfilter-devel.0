From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] make happy cracking message more verbose
Date: Fri, 07 Nov 2003 00:45:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FAADD04.7020200@trash.net>
References: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Maciej,
I made a similar change today to give me the name
of the offending process after receiving these messages
for 8 days. It turned out to be an unrelated bug, located
in skb_copy_expand. Luckily this message gave me the
right pointer, but I don't see the point in totally
bloating the code just for some information that is at
best of limited use in debugging the problem. If anything,
we should print the name of the process producing the
packets, or "kernel" if they are produced out of process
context. Still I don't see the point in iptables trying
to perform IDS actions, in my opinion a counter should
be incremented and nothing should be printed at all.

Best regards,
Patrick

Maciej Soltysiak wrote:

>Hi,
>
>there are places in netfilter where it prints:
>ipt_hoop: happy cracking.
>
>Which doesn't explain a thing to non-netfilter hackers.
>I decided to make those a bit more verbose to the user.
>
>It writes information what was wrong.
>Effects of this patch:
>- if the sk_buff->len was to short, print it out
>- if header lenght was to short, print it out also
>- Write what where the lengths expected.
>- Additional debug information as to in which file, which function did
>  it occur.
>- Add a similar check to ip6 (it was ifdef'd)
>
>I have one question about it.
>
>If we have:
>
>	int len = (*pskb)->nh.iph->ihl * 4;
>
>Is it possible to have a NULL pointer dereference here with (*pskb)->nh
>being NULL in:
>ip_conntrack_local()
>ipt_local_out_hook()
>ipt_local_hook()
>ip6t_local_out_hook()
>ip6t_local_hook()
>
>Should we check for nh, nh.iph first here, or are we okay to rely on
>other functions to initialize it correctly, or disallowing for a code path
>with these being NULL?
>
>
>Please comment this patch.
>
>I am also attaching the patch mime'd just in case.
>
>Regards,
>Maciej
>
>diff -u linux.orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux/net/ipv4/netfilter/ip_conntrack_standalone.c
>--- linux.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-06 20:36:25.000000000 +0100
>+++ linux/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-06 19:38:48.000000000 +0100
>@@ -215,14 +215,35 @@
> 				       const struct net_device *out,
> 				       int (*okfn)(struct sk_buff *))
> {
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int len = (*pskb)->nh.iph->ihl * 4;
>+	int hdrlen = sizeof(struct iphdr);
>+	int bad = 0;
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ipt_hook: happy cracking.\n");
>-		return NF_ACCEPT;
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
>+		bad = 1;
> 	}
>-	return ip_conntrack_in(hooknum, pskb, in, out, okfn);
>+
>+	if (len < hdrlen) {
>+		if (net_ratelimit())
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" IPv4 header too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				len, hdrlen);
>+		bad = 1;
>+	}
>+
>+	if (bad == 1)
>+		return NF_ACCEPT;
>+	else
>+		return ip_conntrack_in(hooknum, pskb, in, out, okfn);
> }
>
> /* Connection tracking may drop packets, but never alters them, so
>diff -u linux.orig/net/ipv4/netfilter/iptable_filter.c linux/net/ipv4/netfilter/iptable_filter.c
>--- linux.orig/net/ipv4/netfilter/iptable_filter.c	2003-09-08 21:50:01.000000000 +0200
>+++ linux/net/ipv4/netfilter/iptable_filter.c	2003-11-06 19:38:57.000000000 +0100
>@@ -111,15 +111,35 @@
> 		   const struct net_device *out,
> 		   int (*okfn)(struct sk_buff *))
> {
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int len = (*pskb)->nh.iph->ihl * 4;
>+	int hdrlen = sizeof(struct iphdr);
>+	int bad = 0;
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ipt_hook: happy cracking.\n");
>-		return NF_ACCEPT;
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
>+		bad = 1;
>+	}
>+
>+	if (len < hdrlen) {
>+		if (net_ratelimit())
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" IPv4 header too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				len, hdrlen);
>+		bad = 1;
> 	}
>
>-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
>+	if (bad == 1)
>+		return NF_ACCEPT;
>+	else
>+		return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
> }
>
> static struct nf_hook_ops ipt_ops[] = {
>diff -u linux.orig/net/ipv4/netfilter/iptable_mangle.c linux/net/ipv4/netfilter/iptable_mangle.c
>--- linux.orig/net/ipv4/netfilter/iptable_mangle.c	2003-09-08 21:50:22.000000000 +0200
>+++ linux/net/ipv4/netfilter/iptable_mangle.c	2003-11-06 19:39:06.000000000 +0100
>@@ -149,14 +149,34 @@
> 	u_int32_t saddr, daddr;
> 	unsigned long nfmark;
>
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int len = (*pskb)->nh.iph->ihl * 4;
>+	int hdrlen = sizeof(struct iphdr);
>+	int bad = 0;
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ipt_hook: happy cracking.\n");
>-		return NF_ACCEPT;
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
>+		bad = 1;
> 	}
>
>+	if (len < hdrlen) {
>+		if (net_ratelimit())
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" IPv4 header too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				len, hdrlen);
>+		bad = 1;
>+	}
>+
>+	if (bad == 1)
>+		return NF_ACCEPT;
>+
> 	/* Save things which could affect route */
> 	nfmark = (*pskb)->nfmark;
> 	saddr = (*pskb)->nh.iph->saddr;
>diff -u linux.orig/net/ipv6/netfilter/ip6table_filter.c linux/net/ipv6/netfilter/ip6table_filter.c
>--- linux.orig/net/ipv6/netfilter/ip6table_filter.c	2003-09-08 21:49:52.000000000 +0200
>+++ linux/net/ipv6/netfilter/ip6table_filter.c	2003-11-06 19:40:12.000000000 +0100
>@@ -111,15 +111,19 @@
> 		   const struct net_device *out,
> 		   int (*okfn)(struct sk_buff *))
> {
>-#if 0
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int hdrlen = sizeof(struct ipv6hdr);
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ip6t_hook: happy cracking.\n");
>+			printk("ip6t_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
> 		return NF_ACCEPT;
> 	}
>-#endif
>
> 	return ip6t_do_table(pskb, hook, in, out, &packet_filter, NULL);
> }
>diff -u linux.orig/net/ipv6/netfilter/ip6table_mangle.c linux/net/ipv6/netfilter/ip6table_mangle.c
>--- linux.orig/net/ipv6/netfilter/ip6table_mangle.c	2003-09-08 21:50:02.000000000 +0200
>+++ linux/net/ipv6/netfilter/ip6table_mangle.c	2003-11-06 19:40:17.000000000 +0100
>@@ -148,15 +148,19 @@
> 	u_int8_t hop_limit;
> 	u_int32_t flowlabel;
>
>-#if 0
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int hdrlen = sizeof(struct ipv6hdr);
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ip6t_hook: happy cracking.\n");
>+			printk("ip6t_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
> 		return NF_ACCEPT;
> 	}
>-#endif
>
> 	/* FIXME: Push down to extensions --RR */
> 	if (skb_is_nonlinear(*pskb) && skb_linearize(*pskb, GFP_ATOMIC) != 0)
>
>------------------------------------------------------------------------
>
>diff -u linux.orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux/net/ipv4/netfilter/ip_conntrack_standalone.c
>--- linux.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-06 20:36:25.000000000 +0100
>+++ linux/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-06 19:38:48.000000000 +0100
>@@ -215,14 +215,35 @@
> 				       const struct net_device *out,
> 				       int (*okfn)(struct sk_buff *))
> {
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int len = (*pskb)->nh.iph->ihl * 4;
>+	int hdrlen = sizeof(struct iphdr);
>+	int bad = 0;
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ipt_hook: happy cracking.\n");
>-		return NF_ACCEPT;
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
>+		bad = 1;
> 	}
>-	return ip_conntrack_in(hooknum, pskb, in, out, okfn);
>+
>+	if (len < hdrlen) {
>+		if (net_ratelimit())
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" IPv4 header too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				len, hdrlen);
>+		bad = 1;
>+	}
>+
>+	if (bad == 1)
>+		return NF_ACCEPT;
>+	else
>+		return ip_conntrack_in(hooknum, pskb, in, out, okfn);
> }
> 
> /* Connection tracking may drop packets, but never alters them, so
>diff -u linux.orig/net/ipv4/netfilter/iptable_filter.c linux/net/ipv4/netfilter/iptable_filter.c
>--- linux.orig/net/ipv4/netfilter/iptable_filter.c	2003-09-08 21:50:01.000000000 +0200
>+++ linux/net/ipv4/netfilter/iptable_filter.c	2003-11-06 19:38:57.000000000 +0100
>@@ -111,15 +111,35 @@
> 		   const struct net_device *out,
> 		   int (*okfn)(struct sk_buff *))
> {
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int len = (*pskb)->nh.iph->ihl * 4;
>+	int hdrlen = sizeof(struct iphdr);
>+	int bad = 0;
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ipt_hook: happy cracking.\n");
>-		return NF_ACCEPT;
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
>+		bad = 1;
>+	}
>+
>+	if (len < hdrlen) {
>+		if (net_ratelimit())
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" IPv4 header too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				len, hdrlen);
>+		bad = 1;
> 	}
> 
>-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
>+	if (bad == 1)
>+		return NF_ACCEPT;
>+	else
>+		return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
> }
> 
> static struct nf_hook_ops ipt_ops[] = {
>diff -u linux.orig/net/ipv4/netfilter/iptable_mangle.c linux/net/ipv4/netfilter/iptable_mangle.c
>--- linux.orig/net/ipv4/netfilter/iptable_mangle.c	2003-09-08 21:50:22.000000000 +0200
>+++ linux/net/ipv4/netfilter/iptable_mangle.c	2003-11-06 19:39:06.000000000 +0100
>@@ -149,14 +149,34 @@
> 	u_int32_t saddr, daddr;
> 	unsigned long nfmark;
> 
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int len = (*pskb)->nh.iph->ihl * 4;
>+	int hdrlen = sizeof(struct iphdr);
>+	int bad = 0;
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ipt_hook: happy cracking.\n");
>-		return NF_ACCEPT;
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
>+		bad = 1;
> 	}
> 
>+	if (len < hdrlen) {
>+		if (net_ratelimit())
>+			printk("ipt_hook: happy cracking at %s in %s."
>+				" IPv4 header too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				len, hdrlen);
>+		bad = 1;
>+	}
>+
>+	if (bad == 1)
>+		return NF_ACCEPT;
>+
> 	/* Save things which could affect route */
> 	nfmark = (*pskb)->nfmark;
> 	saddr = (*pskb)->nh.iph->saddr;
>diff -u linux.orig/net/ipv6/netfilter/ip6table_filter.c linux/net/ipv6/netfilter/ip6table_filter.c
>--- linux.orig/net/ipv6/netfilter/ip6table_filter.c	2003-09-08 21:49:52.000000000 +0200
>+++ linux/net/ipv6/netfilter/ip6table_filter.c	2003-11-06 19:40:12.000000000 +0100
>@@ -111,15 +111,19 @@
> 		   const struct net_device *out,
> 		   int (*okfn)(struct sk_buff *))
> {
>-#if 0
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int hdrlen = sizeof(struct ipv6hdr);
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ip6t_hook: happy cracking.\n");
>+			printk("ip6t_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
> 		return NF_ACCEPT;
> 	}
>-#endif
> 
> 	return ip6t_do_table(pskb, hook, in, out, &packet_filter, NULL);
> }
>diff -u linux.orig/net/ipv6/netfilter/ip6table_mangle.c linux/net/ipv6/netfilter/ip6table_mangle.c
>--- linux.orig/net/ipv6/netfilter/ip6table_mangle.c	2003-09-08 21:50:02.000000000 +0200
>+++ linux/net/ipv6/netfilter/ip6table_mangle.c	2003-11-06 19:40:17.000000000 +0100
>@@ -148,15 +148,19 @@
> 	u_int8_t hop_limit;
> 	u_int32_t flowlabel;
> 
>-#if 0
>+	/* More verbosity to happy cracking by Maciej Soltysiak
>+	 * <solt@dns.toxicfilms.tv> */
>+	int hdrlen = sizeof(struct ipv6hdr);
>+
> 	/* root is playing with raw sockets. */
>-	if ((*pskb)->len < sizeof(struct iphdr)
>-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
>+	if ((*pskb)->len < hdrlen) {
> 		if (net_ratelimit())
>-			printk("ip6t_hook: happy cracking.\n");
>+			printk("ip6t_hook: happy cracking at %s in %s."
>+				" sk_buff too short: %u. Expected: %u\n",
>+				__FUNCTION__, __FILE__,
>+				(*pskb)->len, hdrlen);
> 		return NF_ACCEPT;
> 	}
>-#endif
> 
> 	/* FIXME: Push down to extensions --RR */
> 	if (skb_is_nonlinear(*pskb) && skb_linearize(*pskb, GFP_ATOMIC) != 0)
>  
>
