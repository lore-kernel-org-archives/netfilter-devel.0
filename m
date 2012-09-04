From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Tue, 4 Sep 2012 10:58:13 +0200
Message-ID: <20120904085813.GA24911@1984>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
 <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
 <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
 <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
 <20120903153121.GA19926@1984>
 <20120903192455.GA3527@1984>
 <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
 <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
 <CAHo-OoyEKNM4ZL5ucrrjWGOFu6iizNBzvsKUBbd5aVtpccG0hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46516 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab2IDI6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:58:19 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-OoyEKNM4ZL5ucrrjWGOFu6iizNBzvsKUBbd5aVtpccG0hw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 03, 2012 at 10:29:40PM -0700, Maciej =C5=BBenczykowski wrot=
e:
[...]
> > Not solved:
> > 4. Since NOTRACK now always maps to CT, "-j NOTRACK"
> >    has become unusable on sufficiently old kernels.
> >    Should we even bother?
>=20
> Yes, we must, otherwise distros can't upgrade to latest iptables
> without either patching or upgrading kernel.

Why not? They will upgrade and they will start using the CT target
sooner than any other, which seems good to me.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
