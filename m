From: Steven Ayre <steveayre@gmail.com>
Subject: performing dnat from userspace with libnetfilter_conntrack
Date: Mon, 27 Sep 2010 11:09:57 +0100
Message-ID: <AANLkTinVKv6jd54PWNUj-BgQUSWVHvi9JQqPb_Fno2a_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42546 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0I0KJ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:09:59 -0400
Received: by fxm3 with SMTP id 3so1668046fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2010 03:09:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm trying to perform DNAT from within my userspace program to a dynamic host.

I have in nat PREROUTING a NFQUEUE rule that gives the packet to my
program. I am trying to setup a conntrack rule at this time before
accepting the packet. The NFQUEUE part works just fine. However I am
having trouble adding the conntrack entry.

I also have a SNAT rule in POSTROUTING that ensures all reply packets
come via the server performing the DNAT.

This is the code I currently have:

               /* Pseudocode showing data types */
              /* All IPs and ports are in network byte order */
              struct iphdr *ip = (struct iphdr*)payload; // payload is
char* from nfq_get_payload
              struct tcphdr *tcp = (struct tcphdr*)(ip + ip->ihl*4);
              uint32_t new_daddr;
              uint16_t new_dport;
              inet_pton(AF_INET, "a.b.c.d", &new_daddr);
              new_dport = htons(e);

               /* Add a new conntrack entry */
               if (!(ct = nfct_new())) {
                       perror("nfct_new");
                       return -1;
               }
               nfct_set_attr_u8(ct, ATTR_ORIG_L3PROTO, AF_INET);
               nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
               nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_SRC, ip->saddr);
               nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_DST, ip->daddr);
               nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, tcp->source);
               nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, tcp->dest);
               nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);
               nfct_set_attr_u32(ct, ATTR_REPL_IPV4_SRC, ip->saddr);
               nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, ip->daddr);
               nfct_set_attr_u32(ct, ATTR_DNAT_IPV4, new_daddr);
               nfct_set_attr_u16(ct, ATTR_DNAT_PORT, new_dport);
               nfct_set_attr_u32(ct, ATTR_TIMEOUT, 120);
               if (nfct_query(globals.cth, NFCT_Q_CREATE, ct) < 0) {
                       perror("nfct_query");
                       return -1;
               }
               nfct_destroy(ct);

When the above code runs I get the following event:
    [NEW] tcp      6 120 src=81.27.101.233 dst=81.27.101.231
sport=52357 dport=1720 [UNREPLIED] src=81.27.101.231 dst=81.27.101.233
sport=1720 dport=52357

But when using the DNAT target I get the following:
    [NEW] tcp      6 120 SYN_SENT src=81.27.101.233 dst=81.27.101.231
sport=39591 dport=1720 [UNREPLIED] src=81.27.101.232 dst=81.27.101.231
sport=1721 dport=39591

There's a difference in the events, and while the DNAT target works my
conntrack entry does not. The event when I create the conntrack entry
doesn't actually show the DNAT destination at all!

Does anyone know what I'm doing wrong?

Also, do I need to manually mangle the first packet to perform the
DNAT or will netfilter do this for me after I accept the packet due to
the conntrack entry? I have working code to do this if it's required.

-Steve
