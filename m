From: Patrick McHardy <kaber@trash.net>
Subject: Re: Question about ipt_REJECT
Date: Mon, 04 Jan 2010 13:57:22 +0100
Message-ID: <4B41E5B2.1080609@trash.net>
References: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Xiong Wu <xiong.wu1981@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33490 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0ADM50 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:57:26 -0500
In-Reply-To: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Xiong Wu wrote:
> Hi All,
> 
> I found the TCP RST packet sent from ipt_REJECT target isn't able to
> update related conntrack state.
> 
> I install a 2.6.30.10 kernel as a router and add a iptables rule with
> REJECT target to reset specific connections.  However  I found  when
> the packets is handled by the ipt_REJECT and the TCP RST packet is
> sent, the related conntrack state isn't updated to CLOSE state.
> 
> Then I review the ipt_REJECT codes. I found the target attach the old
> conntrack to RST packet as:
> {
>    nf_ct_attach(nskb, oldskb);
>    ip_local_out(nskb);
> }
> 
> Therefor the nf_conntrack_in() will ignore this RST packet due to the
> nfct is valid in skb.
> {
>      if (skb->nfct) {
>                     NF_CT_STAT_INC_ATOMIC(net, ignore);
>                     return NF_ACCEPT;
>      }
> }
> 
> 
> Is there any reason to attach the old conntrack to new RST skb?  I
> think let the RST packet lookup and update related conntrack is
> better.

The packet that is rejected might be half-way mangled by NAT (DNAT
performed, SNAT not yet performed). In this state conntrack is
be unable to associate the generated RST packet with the conntrack
entry. The same applies when you reject the first packet of a
connection which hasn't entered the hash tables yet.

Usually this shouldn't be a problem exactly because you would
normally reject the first packet of a connection, so it wouldn't
be placed in the conntrack hash.

