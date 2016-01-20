From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: bridge: add nf_afinfo to enable
 queuing to userspace
Date: Wed, 20 Jan 2016 16:52:54 +0100
Message-ID: <20160120155254.GA10903@breakpoint.cc>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-2-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115094905.GA7462@breakpoint.cc>
 <569F9ADD.40500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?st=E9phane?= bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50344 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933838AbcATPw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 10:52:57 -0500
Content-Disposition: inline
In-Reply-To: <569F9ADD.40500@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

st=E9phane bryant <stephane.ml.bryant@gmail.com> wrote:
> >> --- a/net/bridge/br_netfilter_hooks.c
> >> +++ b/net/bridge/br_netfilter_hooks.c
> >> @@ -999,6 +999,46 @@ static struct ctl_table brnf_table[] =3D {
> >>  };
> >>  #endif
> >> =20
> >> +static void nf_br_saveroute(const struct sk_buff *skb,
> >> +			    struct nf_queue_entry *entry)
> >=20
> > Please put all of these functions into a new file.
> > CONFIG_BRIDGE_NETFILTER will be deprecated, this is the glue part
> > that allows a bridge to use arp and /ip(6)tables.
> >=20
>=20
> Sorry if i am a bit of a slow-learner, but i assume you mean followin=
g
> what's done for, e.g., ipv4, and have this into a bridge/netfilter.c =
and
> initializing this part of the subsystem.

bridge/netfilter.c sounds good.
Another option would be net/bridge/netfilter/nf_tables_bridge.c
(assuming that this is only added for use with nft as opposed to adding
 a nfqueue target to ebtables).

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
