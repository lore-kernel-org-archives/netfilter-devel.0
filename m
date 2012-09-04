From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Mon, 3 Sep 2012 22:29:40 -0700
Message-ID: <CAHo-OoyEKNM4ZL5ucrrjWGOFu6iizNBzvsKUBbd5aVtpccG0hw@mail.gmail.com>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
	<CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
	<alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
	<CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
	<20120903153121.GA19926@1984>
	<20120903192455.GA3527@1984>
	<CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
	<alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> I think so too.
> Furthermore, I have refined Pablo's patch.
>
> 0. vcurrent was not updated, now done.
> 1. Loading libxt_NOTRACK.so would still ask the kernel for NOTRACK.0
>    (function "compatible_revision"), now addressed.
> 2. NOTRACK.0 can now directly map to CT.1, instead of going through CT.0.
> 3. Do away with libxt_NOTRACK.c, and resolve the dlopen call by
>    providing a symlink.

Nice.

> Not solved:
> 4. Since NOTRACK now always maps to CT, "-j NOTRACK"
>    has become unusable on sufficiently old kernels.
>    Should we even bother?

Yes, we must, otherwise distros can't upgrade to latest iptables
without either patching or upgrading kernel.
It's really nice that the two aren't that tightly coupled.
Unless by old kernels you mean pre-RHEL5 kernels.
