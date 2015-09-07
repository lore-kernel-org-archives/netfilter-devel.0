From: =?UTF-8?Q?Ville_Skytt=C3=A4?= <ville.skytta@iki.fi>
Subject: Re: [PATCH] iptables: Spelling fixes
Date: Mon, 7 Sep 2015 12:49:58 +0300
Message-ID: <CABr9L5CuX=1Z3bGWjqXaY=QuUeoCQZ683-8QKe+vkdDi2GWksQ@mail.gmail.com>
References: <20150905210746.GA13600@salvia> <1441520550-526-1-git-send-email-ville.skytta@iki.fi>
 <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr> <CABr9L5BtsG-mzA4LrN0TANPFG-9L8bOeLL6O=M9D4P9d52putw@mail.gmail.com>
 <alpine.DEB.2.10.1509062017380.12868@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36400 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbIGJuT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 05:50:19 -0400
Received: by lbcao8 with SMTP id ao8so36459048lbc.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2015 02:50:17 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.10.1509062017380.12868@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 6, 2015 at 9:21 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Sun, 6 Sep 2015, Ville Skytt=C3=A4 wrote:
>
>> If it doesn't, I suggest applying my original patch which didn't do
>> anything but the spelling fixes -- I'm not going to spend any more t=
ime
>> on this.
>
> Your original patch does not follow either the comment styles for fil=
es
> under net/, therefore was you asked to fix it.

This is getting more and more confusing to me. My patch does not touch
any files under net/, nor is there a net/ directory in the iptables
repository in the first place as far as I can tell. My original patch
follows whatever the comment style was in the files/blocks touched, it
just fixes spelling errors. If people want the style changed, I think
the most productive use of everyone's time would be if someone who
actually knows what the desired comment style is would either apply my
original patch as-is and then do the desired style changes on top of
that. Or just reject my patch and make or don't make the style
changes, but I don't think this discussion is on a very productive
track. I'm going to do my part and shut up now, sorry about the noise
:)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
