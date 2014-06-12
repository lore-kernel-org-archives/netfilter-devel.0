From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 20:33:21 +0900
Message-ID: <CAGCkEt0=-PJSEyWLPwgouzFydMZNnaxjqP9BJAjN71KxELyQMg@mail.gmail.com>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
	<20140612001807.GB22240@breakpoint.cc>
	<CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
	<20140612094842.GA1982@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:41790 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016AbaFLLdX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:33:23 -0400
Received: by mail-la0-f44.google.com with SMTP id hr17so610807lab.31
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 04:33:21 -0700 (PDT)
In-Reply-To: <20140612094842.GA1982@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello, thank you for taking your time.

2014-06-12 18:48 GMT+09:00 Florian Westphal <fw@strlen.de>:
> ct1 and ct2 zones would then always be equal except if
> both have ATTR_ZONE set and the zones are different.

I think it reasonable too, but attr holds old value if it was unset.
Too much doubt?
