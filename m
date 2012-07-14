From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Sat, 14 Jul 2012 17:24:55 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207141723001.21350@frira.zrqbmnf.qr>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de> <1341964350-13809-5-git-send-email-jengelh@inai.de> <20120712154957.GE18793@1984> <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr> <20120713091648.GA20796@1984>
 <CAHo-OowA3Tc4DF_OGMOQxiqriqOu-63FM8pbaHwdJx4D0ww7gA@mail.gmail.com> <20120714131111.GB31130@1984> <CAGuaRCuu0LcRDdOFESppq5TNSbBhm9p2w1yZkorw3yTshLecMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	=?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:60237 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab2GNPY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 11:24:58 -0400
In-Reply-To: <CAGuaRCuu0LcRDdOFESppq5TNSbBhm9p2w1yZkorw3yTshLecMA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2012-07-14 16:49, Aft nix wrote:
>>> > @David: just to put you into context. Jan is proposing to merge
>>> > xt_SYSRQ into mainstream, we are discussing if it would be better to
>>> > make it out of it (so people do not depend on the firewalling
>>> > utilities to get it working) based on a different proposal described
>>> > above.
>
>Hi Jan,
>
>I don't know if it goes to main line kernel eventually, i want this feature
>right now. Right now i have to physically go the office rack to reboot in a
>case of kernel crash. Office IT people don't provide IPKVM stuffs in development
>servers, they only give it to "production" severs.
>
>I really think its nice touch. Is it available in xtable-addons, or i
>just apply your patch directly?

It is in Xt-a, and I try to upstream it.

Again, I emphasize that xt_SYSRQ can be combined with other matches
of Xtables, and that why it should be merged rather than a separate
subsystem of some kind.
