From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 22:43:28 +0900
Message-ID: <20140612134328.GA24379@gmail.com>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
 <20140612001807.GB22240@breakpoint.cc>
 <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
 <20140612094842.GA1982@breakpoint.cc>
 <CAGCkEt0=-PJSEyWLPwgouzFydMZNnaxjqP9BJAjN71KxELyQMg@mail.gmail.com>
 <20140612115925.GB1982@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34250 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaFLNnf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:43:35 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so990839pdj.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 06:43:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140612115925.GB1982@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 12, 2014 at 01:59:25PM +0200, Florian Westphal wrote:
> > > ct1 and ct2 zones would then always be equal except if
> > > both have ATTR_ZONE set and the zones are different.
> > 
> > I think it reasonable too, but attr holds old value if it was unset.
> 
> Yes, but nfct_get_attr_u* return 0 if attribute bit is unset.

That's why you do not use the raw value. I should have understood
it earlyer, sorry.

> So I think this should work.

I agree with you, thank you.
Should we clear errno in that cmp_zone() before return?
