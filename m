From: Aft nix <aftnix@gmail.com>
Subject: Re: Help parsing options with iptables extension
Date: Mon, 17 Sep 2012 16:17:12 +0600
Message-ID: <CAGuaRCv-FAR=5igWbZSbUJZ=62pv73y1rUkJiONrOHBeKrebow@mail.gmail.com>
References: <CAGuaRCuz+8_CPsXpouoDOdkg-6ezjuZrgc=UVqe-JqYwz2U2QQ@mail.gmail.com>
	<alpine.LNX.2.01.1209170457460.13524@nerf07.vanv.qr>
	<CAGuaRCvkfwQYgrSvsKeU5RXvuw=YY5a80baJVqHBQkf7RUfjAg@mail.gmail.com>
	<alpine.LNX.2.01.1209171208290.20667@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58812 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2IQKRN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:17:13 -0400
Received: by ieak13 with SMTP id k13so265055iea.19
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Sep 2012 03:17:12 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1209171208290.20667@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 17, 2012 at 4:11 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Monday 2012-09-17 11:23, Aft nix wrote:
>>
>>Thanks for detailed explanation. I will try stuff this way and will
>>get back with further code.(In between, when the module
>>is finished, given that its not a generic enough use case, will the
>>module will be accepted in xtables-addons(I'm actually
>>counting on the reviews by experts like you)?
>
> Well, you should post early, and in small logical self-contained bites.
>
> Start before it is finished.

Should i post it in PATCH form? Like my xt_OBSF.c is now built
ok(haven't tested it because libxt_OBSF.c is not ready). So may be
should post xt_OBSF.c/xt_OBSF.h in PATCH?


-- 
-aft
