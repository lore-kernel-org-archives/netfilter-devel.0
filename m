From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Mon, 03 Sep 2012 10:33:55 +0200
Message-ID: <112224558.YVgvUMStDL@gentoovm>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com> <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr> <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:47585 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2ICIeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:34:05 -0400
In-Reply-To: <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 03 September 2012 15:57:53 you wrote:
> So no objections from you, right? :)

Meanwhile, -m state lives on.

In all honesty, if you're going to obliterate things like this, it's arguably 
only fair to also implement something in your userland tools to catch the 
change, throw a deprecated warning and appropriately modify it to use CT 
instead.

I would argue the same for those who wish to see the death of -m state (myself 
included)

Regards,
Oliver
