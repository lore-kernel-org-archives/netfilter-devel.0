From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Mon, 3 Sep 2012 17:14:45 -0700
Message-ID: <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
	<CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
	<alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
	<CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
	<20120903153121.GA19926@1984>
	<20120903192455.GA3527@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
	Jan Engelhardt <jengelh@inai.de>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20120903192455.GA3527@1984>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

+<----->if (cs->target->alias == NULL)^M
+<-----><------>strcpy(cs->target->t->u.user.name, cs->jumpto);^M
+<----->else^M
+<-----><------>strcpy(cs->target->t->u.user.name, cs->target->alias);^M

I'd have probably written if (cs->target->alias) copy(alias) else copy(jumpto)

doesn't this all really belong in the CT files now?
ie. libxt_CT.c not libxt_NOTRACK.c

Either way, LGTM.
