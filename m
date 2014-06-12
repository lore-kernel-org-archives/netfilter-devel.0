From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 13:59:25 +0200
Message-ID: <20140612115925.GB1982@breakpoint.cc>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
 <20140612001807.GB22240@breakpoint.cc>
 <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
 <20140612094842.GA1982@breakpoint.cc>
 <CAGCkEt0=-PJSEyWLPwgouzFydMZNnaxjqP9BJAjN71KxELyQMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54803 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbaFLL71 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:59:27 -0400
Content-Disposition: inline
In-Reply-To: <CAGCkEt0=-PJSEyWLPwgouzFydMZNnaxjqP9BJAjN71KxELyQMg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
>  Hello, thank you for taking your time.
> 
> 2014-06-12 18:48 GMT+09:00 Florian Westphal <fw@strlen.de>:
> > ct1 and ct2 zones would then always be equal except if
> > both have ATTR_ZONE set and the zones are different.
> 
> I think it reasonable too, but attr holds old value if it was unset.

Yes, but nfct_get_attr_u* return 0 if attribute bit is unset.

So I think this should work.
