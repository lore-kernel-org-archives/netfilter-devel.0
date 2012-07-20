From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Problem with iptables accounting in Ubuntu Precise 12.04 LTS
Date: Sat, 21 Jul 2012 01:06:58 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207210105220.3615@frira.zrqbmnf.qr>
References: <CAHHzA4XF-f9LMTAmFpC65u0ikFd-9Sd76A0q+Qr5E9Xbr5eVEQ@mail.gmail.com> <alpine.LNX.2.01.1207210014250.2166@frira.zrqbmnf.qr> <CAHHzA4WPdhRanibDKtyevyNRLvkM6-0+NpcFg5Y6kswm+aLx4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: John Tran <njhtran@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:52955 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2GTXHB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:07:01 -0400
In-Reply-To: <CAHHzA4WPdhRanibDKtyevyNRLvkM6-0+NpcFg5Y6kswm+aLx4Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-07-21 00:50, John Tran wrote:

>I searched my entire hard drive, apparently xt_ACCOUNT.ko is not one
>of the files that comes with Precise Pangolin.  Is there a known
>Ubuntu distribution that does have it working properly?

Maybe - I don't care about what Ubuntu does or does not.
Do make sure that you really have Xtables-addons installed properly, 
especially when using the extra DKMS hurdle.
