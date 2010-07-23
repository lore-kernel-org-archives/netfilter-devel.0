From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] iptables: use skb->len for accounting
Date: Fri, 23 Jul 2010 08:58:22 +0200
Message-ID: <1279868302.2482.113.camel@edumazet-laptop>
References: <1279856088-9004-1-git-send-email-xiaosuo@gmail.com>
	 <1279866541.2482.79.camel@edumazet-laptop>
	 <AANLkTikFp9tjtYz5c0GTOfcS1DD8v6fLvBUVVeBVbsns@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AANLkTikFp9tjtYz5c0GTOfcS1DD8v6fLvBUVVeBVbsns@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le vendredi 23 juillet 2010 =C3=A0 14:47 +0800, Changli Gao a =C3=A9cri=
t :
> On Fri, Jul 23, 2010 at 2:29 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> > Le vendredi 23 juillet 2010 =C3=A0 11:34 +0800, Changli Gao a =C3=A9=
crit :
> >> iptables: use skb->len for accounting
> >>
> >> use skb->len for accounting as xt_quota does.
> >>
> >
> > Why ?
> >
> > This is a gratuitous change, unless you have very strong arguments.
> >
> > xt_quota is an exception, dont change all others because of it !
>=20
> exception ? Why ?

Because it handles all protocols...

So skb->len is a shortcut, an approximation if you want.

At IPV4 level, ip->tot_len is an exact value.



