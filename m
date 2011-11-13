From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: unaligned ip header due to
 ip_route_me_harder()->pskb_expand_head()
Date: Sun, 13 Nov 2011 18:02:33 +0100
Message-ID: <20111113170233.GA16851@1984>
References: <4EB9449D.8020701@tilera.com>
 <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EBA48F3.8040906@tilera.com>
 <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EBB7E3C.9030402@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Paul Guo <ggang@tilera.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44666 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab1KMRCl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Nov 2011 12:02:41 -0500
Content-Disposition: inline
In-Reply-To: <4EBB7E3C.9030402@tilera.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 10, 2011 at 03:33:16PM +0800, Paul Guo wrote:
>=20
> > Le mercredi 09 novembre 2011 =E0 17:33 +0800, Paul Guo a =E9crit :
> >=20
> >>> or=20
> >>>
> >>> pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)), =
0, GFP_ATOMIC))
> >>
> >> Thanks. This looks better.
> >=20
> > Could you submit an official patch ?
> >=20
> > Thanks !
>=20
> OK. I tried to clone a netfilter branch firstly, but failed. Cloning =
the network
> branch is OK. It looks there is something wrong with the netfilter gi=
t branch,
> or am I doing something wrong? Thanks.

We're not yet back to kernel.org. You can find the temporary trees at:

git://1984.lsi.us.es/net/.git
git://1984.lsi.us.es/net-next/.git

Always use nf / nf-next branches (if they exist). Now there's not
because I don't have enqueued changes for upstream yet.

I need some spare time to contact kernel.org people again and ask for
new account.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
