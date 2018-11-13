From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@sysophe.eu>
Subject: Re: BUG: Fatal in exception in interrupt, at nf_conncount_count
 [regression in 4.19(.1)]
Date: Tue, 13 Nov 2018 08:52:57 +0100
Message-ID: <20181113085257.77e16800@pluto.restena.lu>
References: <20181112150406.1bbb7bee@pluto.restena.lu>
        <20181112141045.3fhxzgv5c7nu2stp@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Yi-Hung Wei <yihung.wei@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181112141045.3fhxzgv5c7nu2stp@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 12 Nov 2018 15:10:45 +0100 Florian Westphal wrote:
> Bruno Pr=C3=A9mont <bonbons@sysophe.eu> wrote:
> > Hi,
> >=20
> > With linux-4.19.1 I'm seeing regular kernel panics since this night
> > with uptime of 5 to 30 minutes in between. System is not heavily loaded=
. =20
> [..]
>=20
> > It looks like those locking related changes may be the cause. =20
>=20
> Yes.
>=20
> > Bisecting it will be hard as I don't have exact packet stream =20
>=20
> No need.  Can you give these three patches a try?
>=20
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=3D73972

I applied them yesterday evening and until now system survived
without panic or other anomaly.

If the fix is confirmed, don't forget to let the patches go to
stable 4.19.x kernels!

Thanks,
Bruno
