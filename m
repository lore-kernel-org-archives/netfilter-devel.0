From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH] conntrack: Flush connections with given work
Date: Tue, 23 Dec 2014 16:42:14 +0100
Message-ID: <CAKfDRXgQO7tjquwv05e-ih15Qj37qUYqfQNFs-AktHs=+mieMg@mail.gmail.com>
References: <1418984305-18857-1-git-send-email-kristian.evensen@gmail.com>
	<20141223135013.GA16553@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:46751 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbaLWPmP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:42:15 -0500
Received: by mail-yk0-f182.google.com with SMTP id 131so3188179ykp.27
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Dec 2014 07:42:15 -0800 (PST)
In-Reply-To: <20141223135013.GA16553@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thanks for your feedback.

On Tue, Dec 23, 2014 at 2:50 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> It would be great if you can refactor the existing filtering in
> ctnetlink_dump_table() to reduce the #ifdef pollution. My suggestion
> is to encapsulate the mark-based filtering code in a
> ctnetlink_filter() function that you can call from the dump and the
> flush paths.

Sounds good. I guess that as long as the only function which calls
ctnetlink_dump_table() and sets c.data is ctnetlink_get_conntrack(),
we can do something like this in ctnetlink_dump_table():

if (cb->data && ctnetlink_apply_filter(cb->data))

And then wrap the mark check in apply_filter in an ifdef.

I will have a v2 ready during the week.

-Kristian
