From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH libmnl] nlmsg: introduce mnl_nlmsg_batch_rest to get the
 rest length
Date: Thu, 20 Apr 2017 12:32:55 +0900
Message-ID: <20170420033255.GA28407@gmail.com>
References: <20170403061127.GA2329@gmail.com>
 <20170413222700.GA5024@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35706 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936990AbdDTDdB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 23:33:01 -0400
Received: by mail-io0-f180.google.com with SMTP id r16so49681664ioi.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 20:33:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170413222700.GA5024@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 12:27:00AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 03, 2017 at 03:11:27PM +0900, Ken-ichirou MATSUZAWA wrote:
> > enables to help to wrap these. As of this C library, we can use
> > this like below without double sized buffer.
> > 
> >     char buf[MNL_SOCKET_BUFFER_SIZE];
> > 
> >     b = mnl_nlmsg_batch_start(buf, sizeof(buf));
> >     nlbuf = mnl_nlmsg_batch_current(b);
> >     rest = mnl_nlmsg_batch_rest(b);
> >     if (rest < NLMSG_HDRLEN)
> >             return false;
> 
> Only for this usecase above?

So far, yes. Is it worthless to apply?

> >     nlh = mnl_nlmsg_put_header(nlbuf);
> 
> Probably we need mnl_nlmsg_put_header_check()?

And I guess mnl_nlmsg_put_extra_header_check will also be needed.
I am going to resend if you intend to apply those.

Thanks,
