From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug in iptables
Date: Fri, 22 Feb 2008 15:47:41 +0100
Message-ID: <47BEE08D.9070003@trash.net>
References: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com> <47B53643.9000107@gmail.com> <47BACB6C.4090000@trash.net> <47BE7917.1030301@gmail.com> <47BED75A.9090204@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020807050203050507030804"
Cc: netfilter-devel@vger.kernel.org
To: justin joseph <justin.cok@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:29197 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756528AbYBVOsV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:48:21 -0500
Received: from edge03 ([192.168.13.238]) by viefep17-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080222144816.QXTV27032.viefep17-int.chello.at@edge03>
          for <netfilter-devel@vger.kernel.org>;
          Fri, 22 Feb 2008 15:48:16 +0100
In-Reply-To: <47BED75A.9090204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020807050203050507030804
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> justin joseph wrote:
>
>> root@hq.enpaq:~# uname -r
>> 2.6.15-29-386
>> root@hq.enpaq:~#
> 
> 
> Thanks, I can reproduce it on current -git. I'll look into it.


OK actually we've never had a check for this in the kernel.
Userspace contains some basic checks based on the chainname,
but this only works for the built-in chains.

This patch adds the proper checks to the kernel. I'm a bit
worried though that this might break some rulesets. So
far we've allowed to create used-defined rules with these
"invalid" matches, which might even be useful to share
chains between multiple hooks, even if some matches will
not match depending on where the jump came from.

Opinions?

--------------020807050203050507030804
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 6a90fb84a7333789aa39810ea5548342967bd27c
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Feb 22 15:45:07 2008 +0100

    [NETFILTER]: {ip,ip6}_tables: check whether interface match is used on valid hooks
    
    Input device matches are only valid in PREROUTING/INPUT/FORWARD, output
    device matches in FORWARD/OUTPUT/POSTROUTING. Iptables userspace contains
    some checks based on the chainname, catching invalid uses in the built-in
    chains, but does't catch invalid matches in user-defined chains.
    
    Add checks for valid device-match usage based on the jumps to a chain.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 600737f..0f4b16d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -155,8 +155,11 @@ ip_packet_match(const struct iphdr *ip,
 }
 
 static bool
-ip_checkentry(const struct ipt_ip *ip)
+ip_checkentry(const struct ipt_entry *e)
 {
+	const struct ipt_ip *ip = &e->ip;
+	unsigned int i;
+
 	if (ip->flags & ~IPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ip->flags & ~IPT_F_MASK);
@@ -167,6 +170,20 @@ ip_checkentry(const struct ipt_ip *ip)
 			 ip->invflags & ~IPT_INV_MASK);
 		return false;
 	}
+	if (e->comefrom &
+	    ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN))) {
+		for (i = 0; i < sizeof(ip->outiface); i++) {
+			if (ip->outiface_mask[i])
+				return false;
+		}
+	}
+	if (e->comefrom &
+	    ((1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_POST_ROUTING))) {
+		for (i = 0; i < sizeof(ip->iniface); i++) {
+			if (ip->iniface_mask[i])
+				return false;
+		}
+	}
 	return true;
 }
 
@@ -589,7 +606,7 @@ check_entry(struct ipt_entry *e, const char *name)
 {
 	struct ipt_entry_target *t;
 
-	if (!ip_checkentry(&e->ip)) {
+	if (!ip_checkentry(e)) {
 		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index bf9bb6e..4f0cb7c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -184,8 +184,11 @@ ip6_packet_match(const struct sk_buff *skb,
 
 /* should be ip6 safe */
 static bool
-ip6_checkentry(const struct ip6t_ip6 *ipv6)
+ip6_checkentry(const struct ip6t_entry *e)
 {
+	const struct ip6t_ip6 *ipv6 = &e->ipv6;
+	unsigned int i;
+
 	if (ipv6->flags & ~IP6T_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ipv6->flags & ~IP6T_F_MASK);
@@ -196,6 +199,20 @@ ip6_checkentry(const struct ip6t_ip6 *ipv6)
 			 ipv6->invflags & ~IP6T_INV_MASK);
 		return false;
 	}
+	if (e->comefrom &
+	    ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN))) {
+		for (i = 0; i < sizeof(ipv6->outiface); i++) {
+			if (ipv6->outiface_mask[i])
+				return false;
+		}
+	}
+	if (e->comefrom &
+	    ((1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_POST_ROUTING))) {
+		for (i = 0; i < sizeof(ipv6->iniface); i++) {
+			if (ipv6->iniface_mask[i])
+				return false;
+		}
+	}
 	return true;
 }
 
@@ -616,7 +633,7 @@ check_entry(struct ip6t_entry *e, const char *name)
 {
 	struct ip6t_entry_target *t;
 
-	if (!ip6_checkentry(&e->ipv6)) {
+	if (!ip6_checkentry(e)) {
 		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}

--------------020807050203050507030804--
