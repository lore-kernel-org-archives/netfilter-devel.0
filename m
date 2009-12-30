From: Bin Liang <liangbin1978@gmail.com>
Subject: Re: Question about ipt_REJECT
Date: Wed, 30 Dec 2009 11:36:07 +0800
Message-ID: <708ca0e40912291936r3468e82fxc2f97339da4af7a0@mail.gmail.com>
References: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Xiong Wu <xiong.wu1981@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:52425 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZL3DgJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:36:09 -0500
Received: by pxi27 with SMTP id 27so6598270pxi.4
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2009 19:36:08 -0800 (PST)
In-Reply-To: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

If the conntrack is in ESTABLISHED state, will it still in this state
after the ipt_REJECT send the RST packet?
If yes, I think this is an issue.

Thanks,
-Bryan

On Tue, Dec 29, 2009 at 3:37 PM, Xiong Wu <xiong.wu1981@gmail.com> wrot=
e:
>
> Hi All,
>
> I found the TCP RST packet sent from ipt_REJECT target isn't able to
> update related conntrack state.
>
> I install a 2.6.30.10 kernel as a router and add a iptables rule with
> REJECT target to reset specific connections. =A0However =A0I found =A0=
when
> the packets is handled by the ipt_REJECT and the TCP RST packet is
> sent, the related conntrack state isn't updated to CLOSE state.
>
> Then I review the ipt_REJECT codes. I found the target attach the old
> conntrack to RST packet as:
> {
> =A0 nf_ct_attach(nskb, oldskb);
> =A0 ip_local_out(nskb);
> }
>
> Therefor the nf_conntrack_in() will ignore this RST packet due to the
> nfct is valid in skb.
> {
> =A0 =A0 if (skb->nfct) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NF_CT_STAT_INC_ATOMIC(net, ign=
ore);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NF_ACCEPT;
> =A0 =A0 }
> }
>
>
> Is there any reason to attach the old conntrack to new RST skb? =A0I
> think let the RST packet lookup and update related conntrack is
> better.
>
>
> Thanks,
> Sean
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Thanks,
-Bin
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
