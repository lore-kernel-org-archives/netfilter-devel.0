From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: performing dnat from userspace with libnetfilter_conntrack
Date: Tue, 28 Sep 2010 15:35:26 +0200
Message-ID: <4CA1EF1E.80002@netfilter.org>
References: <AANLkTinVKv6jd54PWNUj-BgQUSWVHvi9JQqPb_Fno2a_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Steven Ayre <steveayre@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0I1Ned (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:34:33 -0400
In-Reply-To: <AANLkTinVKv6jd54PWNUj-BgQUSWVHvi9JQqPb_Fno2a_@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Steven,

On 27/09/10 12:09, Steven Ayre wrote:
> I'm trying to perform DNAT from within my userspace program to a dynamic host.
>
> I have in nat PREROUTING a NFQUEUE rule that gives the packet to my
> program. I am trying to setup a conntrack rule at this time before
> accepting the packet. The NFQUEUE part works just fine. However I am
> having trouble adding the conntrack entry.
>
> I also have a SNAT rule in POSTROUTING that ensures all reply packets
> come via the server performing the DNAT.
>
> This is the code I currently have:
>
>                 /* Pseudocode showing data types */
>                /* All IPs and ports are in network byte order */
>                struct iphdr *ip = (struct iphdr*)payload; // payload is
> char* from nfq_get_payload
>                struct tcphdr *tcp = (struct tcphdr*)(ip + ip->ihl*4);
>                uint32_t new_daddr;
>                uint16_t new_dport;
>                inet_pton(AF_INET, "a.b.c.d",&new_daddr);
>                new_dport = htons(e);
>
>                 /* Add a new conntrack entry */
>                 if (!(ct = nfct_new())) {
>                         perror("nfct_new");
>                         return -1;
>                 }
>                 nfct_set_attr_u8(ct, ATTR_ORIG_L3PROTO, AF_INET);
>                 nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
>                 nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_SRC, ip->saddr);
>                 nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_DST, ip->daddr);
>                 nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, tcp->source);
>                 nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, tcp->dest);
>                 nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);
>                 nfct_set_attr_u32(ct, ATTR_REPL_IPV4_SRC, ip->saddr);
>                 nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, ip->daddr);
>                 nfct_set_attr_u32(ct, ATTR_DNAT_IPV4, new_daddr);
>                 nfct_set_attr_u16(ct, ATTR_DNAT_PORT, new_dport);
>                 nfct_set_attr_u32(ct, ATTR_TIMEOUT, 120);
>                 if (nfct_query(globals.cth, NFCT_Q_CREATE, ct)<  0) {
>                         perror("nfct_query");
>                         return -1;
>                 }
>                 nfct_destroy(ct);
>
> When the above code runs I get the following event:
>      [NEW] tcp      6 120 src=81.27.101.233 dst=81.27.101.231
> sport=52357 dport=1720 [UNREPLIED] src=81.27.101.231 dst=81.27.101.233
> sport=1720 dport=52357
>
> But when using the DNAT target I get the following:
>      [NEW] tcp      6 120 SYN_SENT src=81.27.101.233 dst=81.27.101.231
> sport=39591 dport=1720 [UNREPLIED] src=81.27.101.232 dst=81.27.101.231
> sport=1721 dport=39591
>
> There's a difference in the events, and while the DNAT target works my
> conntrack entry does not. The event when I create the conntrack entry
> doesn't actually show the DNAT destination at all!
>
> Does anyone know what I'm doing wrong?

It seems that the ATTR_TCP_STATE attribute is missing. Don't forget to 
use NFQUEUE in the raw table in PREROUTING chain.

> Also, do I need to manually mangle the first packet to perform the
> DNAT or will netfilter do this for me after I accept the packet due to
> the conntrack entry? I have working code to do this if it's required.

No.

BTW, you have to set TCP_LIBERAL flag as well to skip the TCP tracking 
(you will have to wait until 2.6.36 to avoid this, and you'll have to 
use the WSCALE attributes instead of setting liberal to inject the 
window scale factor).
