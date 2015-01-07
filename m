From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH v2 1/2] conntrack: Flush connections with a given mark
Date: Wed, 7 Jan 2015 21:05:22 +0100
Message-ID: <CAKfDRXjLRxXSG9zb0RLfF+tgZRy-DKy9Um57GdE3bA7DX3bhZQ@mail.gmail.com>
References: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
	<1419411431-24715-2-git-send-email-kristian.evensen@gmail.com>
	<20150107185653.GA3469@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:46464 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbAGUFX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:05:23 -0500
Received: by mail-yh0-f43.google.com with SMTP id z6so980054yhz.2
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jan 2015 12:05:22 -0800 (PST)
In-Reply-To: <20150107185653.GA3469@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Jan 7, 2015 at 7:56 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 1) strict type checking in the dump case (for the ctnetlink_filter
> object), instead of relying on the genering void * to keep the
> ct_iterate happy. It adds a bit more code but I prefer it like this.
>
> 2) Explicitly reject mark filters when marks are not supported. This
> changes the previous behaviour, but I think this is good to have so
> userspace knows that what it is requesting is not support (instead of
> silently ignoring it).
>
> 3) add helper function to allocate the filter object, so this always
> needs explicit release.
>
> Please, have a look a it and let me know if you're fine with it. I'll
> pass it to net-next (upcoming 3.20).

Thank you for making the improvements, the patch looks a lot better
now! I only have on question/comment. What is the reason behind adding
the ctnl_flush_filter()? Isn't it enough to have ctnetlink_filter()
return 1 in case of match and 0 otherwise. At least, the way I think,
it makes more sense when I read the code that if this function returns
false, we should ignore conntrack entry due to no match. So the check
in ctnetlink_dump_table() should read !ctnetlink_filter(). In
addition, there is a small typo in the commit log. In the last
paragraph it says ctnetlink_apply_filter(). After your changes, it is
just called ctnetlink_filter().

Thanks again for your help.

-Kristian
