From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Mon, 3 Sep 2012 17:31:21 +0200
Message-ID: <20120903153121.GA19926@1984>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
 <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
 <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
 <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56268 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab2ICPbY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:31:24 -0400
Content-Disposition: inline
In-Reply-To: <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 03, 2012 at 03:57:53PM +0800, Cong Wang wrote:
> On Mon, Aug 27, 2012 at 4:04 AM, Jan Engelhardt <jengelh@inai.de> wro=
te:
> > On Sunday 2012-08-26 12:42, Maciej =C5=BBenczykowski wrote:
> >
> >>Sounds like the old -t raw ... -j NOTRACK is replaced by -t raw ...=
 -j
> >>CT --notrack.
> >>Will -j NOTRACK continue to work?  Could it be added as an alias to=
 CT?
> >
> > No, and, dunno. There are currently no provisions for aliasing in t=
he
> > userspace side.
>=20
> So no objections from you, right? :)

Applied, thanks.

I think it can be possible to rewrite the iptables NOTRACK user-space
extension to use the CT target. Still I would need to check if some
more sophisticated aliasing can be possible.

And iptables-save will show the CT target though, but that shouldn't
be a problem.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
