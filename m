From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Sun, 26 Aug 2012 22:04:48 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com> <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.inai.de ([5.9.24.206]:38878 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab2HZUEu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Aug 2012 16:04:50 -0400
In-Reply-To: <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-08-26 12:42, Maciej =C5=BBenczykowski wrote:

>Sounds like the old -t raw ... -j NOTRACK is replaced by -t raw ... -j
>CT --notrack.
>Will -j NOTRACK continue to work?  Could it be added as an alias to CT=
?

No, and, dunno. There are currently no provisions for aliasing in the=20
userspace side.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
