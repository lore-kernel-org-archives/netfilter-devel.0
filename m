From: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Subject: Re: [PATCH] netfilter: don't track ICMPv6 negotiation message.
Date: Fri, 6 Feb 2009 11:30:29 +0100
Message-ID: <200902061130.29873.christoph.paasch@student.uclouvain.be>
References: <200901271007.n0RA78k6023294@toshiba.co.jp> <1233053715-30398-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Leblond <eric@inl.fr>, yasuyuki.kozakai@toshiba.co.jp,
	kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout.sgsi.ucl.ac.be ([130.104.5.77]:57074 "EHLO
	smtp2.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZBFKak convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:30:40 -0500
In-Reply-To: <1233053715-30398-1-git-send-email-eric@inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have two questions regarding this patch.

On Tue January 27 2009, Eric Leblond wrote:
> +	type =3D icmp6h->icmp6_type - 130;
> +	if (type >=3D 0 && type < sizeof(noct_valid_new)
> +	    && noct_valid_new[type]) {
> +		skb->nfct =3D &nf_conntrack_untracked.ct_general;
> +		skb->nfctinfo =3D IP_CT_NEW;
> +		nf_conntrack_get(skb->nfct);
> +		return NF_ACCEPT;
> +	}

Why do you set skb->nfctinfo =3D IP_CT_NEW?
Because in xt_state.c, at state_mt(...) :=20
	if it is in front of an untracked packet (using nf_ct_is_untracked(skb=
)) it
	automatically sets the statebit to UNTRACKED and so the IP_CT_NEW isn'=
t used.

Why do you return NF_ACCEPT and not -NF_ACCEPT?
By returning a positiv value, the packet will continue it's way through=
 the=20
connection tracker.


I hope that I was clear.=20
Please correct me if I'm wrong...

Greetings,

--
Christoph Paasch

=C9cole Polytechnique de Louvain
D=E9partement d'ing=E9nierie informatique

www.rollerbulls.be
--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
