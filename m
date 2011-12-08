From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: nfnetlink and conntrack extension question
Date: Thu, 08 Dec 2011 11:06:31 +0100
Message-ID: <4EE08C27.6080400@balabit.hu>
References: <1322668453.4443.24.camel@nessa.odu> <20111130180902.GA20336@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([213.253.200.34]:50500 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab1LHKGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:06:34 -0500
In-Reply-To: <20111130180902.GA20336@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey Pablo,

On 11/30/2011 07:09 PM, Pablo Neira Ayuso wrote:
> P.S: Any chance to integrate your development with nfgrep? I didn't
> find any time to release the source code yet. I expect to find some
> spare time during the end of year holidays. If I have access to that
> GPL code we can think of some sort of integration nfgrep <-> zorp.

Well, the code itself isn't really about doing content
processing/filtering in kernel-space, but implementing a rule-based
policy engine (think of something like iptables with best-match
evaluation) that effectively makes decisions about which user-space
proxies, if any, are used for processing a connection.

So at the moment I think that while nfgrep matching could be integrated
into the code and would provide some really nice additional features, it
wouldn't be a replacement for the stuff we're doing.

nfgrep's really cool, though, thanks for your work Pablo!

-- 
KOVACS Krisztian

