From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem getting IPv6 port numbers
Date: Fri, 25 Mar 2011 14:29:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103251427500.28161@obet.zrqbmnf.qr>
References: <4D8C7C20.8090500@catseye.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mark Montague <mark@catseye.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52315 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1CYN3Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:29:16 -0400
In-Reply-To: <4D8C7C20.8090500@catseye.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-03-25 12:27, Mark Montague wrote:

> I'm writing a netfilter match extension (xtables-addons 1.33, kernel 2.6.35,
> .family=NFPROTO_UNSPEC) that needs to examine the source and destination port
> numbers of all packets.  The following code successfully gets the port numbers
> for IPv4 TCP and UDP packets:
>
> static bool xt_mymatch_mt(const struct sk_buff *skb,
>                          struct xt_action_param *par)
> {
>        const __be16 *pptr;
>        __be16 _ports[2];
>        int sport = 0;
>        int dport = 0;
>
>        if (par->fragoff == 0) {
>                pptr = skb_header_pointer(skb, par->thoff,
>                        sizeof(_ports), _ports);
>                if (pptr != NULL) {
>                        sport = ntohs(pptr[0]);
>                        dport = ntohs(pptr[1]);
>                }
>        }
>        /* ...remaining code omitted... */
> }
>
> However, when I test this with "telnet ::1 1234", it does not work for IPv6 TCP
> packets (I have not tried with IPv6 UDP packets yet).  By adding printk()
> statements, I've determined that par->fragoff is never 0 for my IPv6 TCP
> packets -- instead, it is large numbers such as 33569744, 2164528116, or
> 2164412871.  However, par->in and par->out are both correct.  par->matchinfo,
> ipv6_hdr(skb)->saddr, and ipv6_hdr(skb)->daddr are also all correct.

It seems that for IPv6, fragoff is only filled when you explicitly test 
for a protocol using -p.
