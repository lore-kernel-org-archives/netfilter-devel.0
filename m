From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Tue, 4 Sep 2012 17:58:16 +0200
Message-ID: <20120904155816.GA20346@1984>
References: <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
 <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
 <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
 <20120903153121.GA19926@1984>
 <20120903192455.GA3527@1984>
 <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
 <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
 <CAHo-OoyEKNM4ZL5ucrrjWGOFu6iizNBzvsKUBbd5aVtpccG0hw@mail.gmail.com>
 <20120904085813.GA24911@1984>
 <alpine.LNX.2.01.1209041706001.15208@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209041706001.15208@frira.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Sep 04, 2012 at 05:15:17PM +0200, Jan Engelhardt wrote:
> On Tuesday 2012-09-04 10:58, Pablo Neira Ayuso wrote:
>=20
> >On Mon, Sep 03, 2012 at 10:29:40PM -0700, Maciej =C5=BBenczykowski w=
rote:
> >[...]
> >> > Not solved:
> >> > 4. Since NOTRACK now always maps to CT, "-j NOTRACK"
> >> >    has become unusable on sufficiently old kernels.
> >> >    Should we even bother?
> >>=20
> >> Yes, we must, otherwise distros can't upgrade to latest iptables
> >> without either patching or upgrading kernel.
> >
> >Why not? They will upgrade and they will start using the CT target
> >sooner than any other, which seems good to me.
> >
> >We also need to add support for real_rev 0 of the CT target. Just to=
           =20
> >make sure that we don't break with old kernels.                     =
           =20
>=20
> Right; but is that not what might be described as "hypocritic"?
> Even after adding support for CT.0, people still need >=3D 2.6.34.
> Where is the non-breakage for them?

Well yes, we have break at some point, but better if we break for
kernels before 2.6.34 than before 3.4 (CT.1 was added there) ;-).

So we're doing is just to trying to do our best to avoid the sure
breakage that will happen in upcoming 3.7 where NOTRACK will be gone.

There's only one single -stable branch that would break using recent
iptables + old kernel.

> (I can't say I feel /too/ bad for the RHEL folks stuck with their
> ancient 2.6.32 :-P )
> (And don't tell me about backports, because in general, they don't
> do that for NF.)

I'm mostly thinking of embedded people, that usually stick to really
old kernels.
