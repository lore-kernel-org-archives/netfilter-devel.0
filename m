From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Fri, 13 Jun 2014 08:12:46 +0900
Message-ID: <CAGCkEt34pLyfV+T6+QzMaEnKo5fL6VL_Wz-mST_BsZz_4FwbBA@mail.gmail.com>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
	<20140612001807.GB22240@breakpoint.cc>
	<CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
	<20140612094842.GA1982@breakpoint.cc>
	<CAGCkEt0=-PJSEyWLPwgouzFydMZNnaxjqP9BJAjN71KxELyQMg@mail.gmail.com>
	<20140612115925.GB1982@breakpoint.cc>
	<20140612134328.GA24379@gmail.com>
	<20140612140547.GC1982@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:60099 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFLXMs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:12:48 -0400
Received: by mail-la0-f43.google.com with SMTP id e16so1047027lan.30
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 16:12:47 -0700 (PDT)
In-Reply-To: <20140612140547.GC1982@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello, thank you for your reply.

2014-06-12 23:05 GMT+09:00 Florian Westphal <fw@strlen.de>:
> Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
>> Should we clear errno in that cmp_zone() before return?
>
> I *think* the best approach would be to not clear it
> at this time.
>
> would solve.  I don't think callers/users should rely on errno
> having any particular value after nfct_cmp() returns, regardless
> of the return value.

I'd read same thing in err30-c and I'll follow your best thought.

Sorry for offtopic:
I think go lang people made an unlikable decision. Its function
can return multiple value, and its c wrapper suite (cgo) normally
returns result and errno as error. They have an ideom like

    if retval, err := function(); err != nil {
        error_processing()
    }

Things you told me is very helpful for wrapping by golang, thanks.
