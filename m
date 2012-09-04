From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Tue, 4 Sep 2012 17:15:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209041706001.15208@frira.zrqbmnf.qr>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com> <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com> <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr> <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
 <20120903153121.GA19926@1984> <20120903192455.GA3527@1984> <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com> <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr> <CAHo-OoyEKNM4ZL5ucrrjWGOFu6iizNBzvsKUBbd5aVtpccG0hw@mail.gmail.com>
 <20120904085813.GA24911@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20120904085813.GA24911@1984>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 2012-09-04 10:58, Pablo Neira Ayuso wrote:

>On Mon, Sep 03, 2012 at 10:29:40PM -0700, Maciej =C5=BBenczykowski wro=
te:
>[...]
>> > Not solved:
>> > 4. Since NOTRACK now always maps to CT, "-j NOTRACK"
>> >    has become unusable on sufficiently old kernels.
>> >    Should we even bother?
>>=20
>> Yes, we must, otherwise distros can't upgrade to latest iptables
>> without either patching or upgrading kernel.
>
>Why not? They will upgrade and they will start using the CT target
>sooner than any other, which seems good to me.
>
>We also need to add support for real_rev 0 of the CT target. Just to  =
         =20
>make sure that we don't break with old kernels.                       =
         =20

Right; but is that not what might be described as "hypocritic"?
Even after adding support for CT.0, people still need >=3D 2.6.34.
Where is the non-breakage for them?

(I can't say I feel /too/ bad for the RHEL folks stuck with their
ancient 2.6.32 :-P )
(And don't tell me about backports, because in general, they don't
do that for NF.)
