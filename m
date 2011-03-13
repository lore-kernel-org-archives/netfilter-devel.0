From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [Fwd: [Bug 29332] xt_recent handles "! --update" wrong]
Date: Sun, 13 Mar 2011 23:00:38 +0800
Message-ID: <AANLkTikS0zi2ncD_aMNQdT+fxjhUQWKihTDAShChT1A_@mail.gmail.com>
References: <4D5E783E.6000600@sessink.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Valentijn Sessink <valentijn@sessink.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1CMPA7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:00:59 -0400
Received: by fxm17 with SMTP id 17so2223127fxm.19
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2011 08:00:58 -0700 (PDT)
In-Reply-To: <4D5E783E.6000600@sessink.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 18, 2011 at 9:46 PM, Valentijn Sessink <valentijn@sessink.nl> wrote:
> Hello Netfilter devs,
>
> As per request from Patrick McHardy:
>> https://bugzilla.kernel.org/show_bug.cgi?id=29332
>> --- Comment #3 from Patrick McHardy <kaber@trash.net>
>> Please submit your patch to netfilter-devel@vger.kernel.org so others
>> can have a look as well.
>
> ... please find attached my proposed patch - free cleanup included.
>
> As noted in Bugzilla, I'm by no means a programmer, so please take my
> patch with a grain of salt. Also, I do realise that fixing bugs and
> cleaning up should probably not be mixed, so you might want to just use
> the simple (but IMHO stupid) fix:
>
> (info->check_set & XT_RECENT_UPDATE && (ret ^ info->invert)))

IMHO, we should keep bugfix patches as clean as possible, so I prefer
the above fix. Thanks.

>
> I hope the problem is trivial enough to not present a test case, but if
> you want one, I'll make one.
>
> Please feel free to throw my patch away and build something more
> sensible ;-)
>

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
