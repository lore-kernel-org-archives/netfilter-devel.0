From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-queue] examples: attaching a conntrack information
Date: Thu, 10 Sep 2015 02:02:08 +0200
Message-ID: <20150910000208.GA5734@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150909095851.GD11843@gmail.com>
 <20150909202932.GC24810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ken-ichirou MATSUZAWA <chamaken@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbbIIXzg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 19:55:36 -0400
Content-Disposition: inline
In-Reply-To: <20150909202932.GC24810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 10:29:32PM +0200, Florian Westphal wrote:
> Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> > This patch enables nf-queue in examples directory to show conntrack
> > information if --enable-nfct configure option is specified.
> 
> Thanks for doing this!

Thanks indeed.

Any chance we can get rid of --enable-nfct configure option?
