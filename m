From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 16:05:47 +0200
Message-ID: <20140612140547.GC1982@breakpoint.cc>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
 <20140612001807.GB22240@breakpoint.cc>
 <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
 <20140612094842.GA1982@breakpoint.cc>
 <CAGCkEt0=-PJSEyWLPwgouzFydMZNnaxjqP9BJAjN71KxELyQMg@mail.gmail.com>
 <20140612115925.GB1982@breakpoint.cc>
 <20140612134328.GA24379@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55113 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbaFLOFu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:05:50 -0400
Content-Disposition: inline
In-Reply-To: <20140612134328.GA24379@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> Should we clear errno in that cmp_zone() before return?

Good question, I don't know.

I *think* the best approach would be to not clear it
at this time.

Its not yet clear to me what problem the zeroing
would solve.  I don't think callers/users should rely on errno
having any particular value after nfct_cmp() returns, regardless
of the return value.
