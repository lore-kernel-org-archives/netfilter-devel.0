From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Thu, 18 Oct 2012 18:51:04 +0200
Message-ID: <20121018165104.GA15142@1984>
References: <1350577344-16321-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37300 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780Ab2JRQvM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:51:12 -0400
Content-Disposition: inline
In-Reply-To: <1350577344-16321-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 18, 2012 at 06:22:24PM +0200, Florian Westphal wrote:
> When users wish to annotate connections with extra information,
> (e.g. "connection came in on interface eth1"), the only way of doing so
> at the moment is using connmarks.
> 
> As connmark is only 32-bit wide, this can become a problem when the
> number of desired meta-information increases (especially true when also
> using connmarks to label policy routing marks, and/or using dpi crap, etc).
> 
> This patch essentially adds a kernel store of (user-defined) label names.
> Users can then assign these names to connections, with as many names per
> connection as desired (current - arbitrarily chosen - limit is 32k
> different names total).
> 
> Also includes match/target extensions to add/match based on connection names
> (or "connection labels").

I like this feature, but I'd propose that the kernel stores a specific
32-bits integer instead (not connmark, something new added as
extension. In user-space we would have a file like:

$ cat /etc/iptables/connlabel.conf
1 "traffic leaving from eth0"
2 "traffic entering eth0"
3 "http traffic"
...

So we can do something like:

iptables -I INPUT -i eth0 -m connlabel --set-connlabel "traffic leaving from eth0"

[ Note I'm proposing (ab)using the match so we can use it together with
targets in one single rule, we're doing that for nfacct so it should
not be a problem ]

The connlabel match will open the file and will look up for that
string.

Then, ctnetlink only dumps a 32-bits integer with the connlabel. We
can extend conntrack to translate connlabels to strings.

The kernel will work with integer, which is good for performance and
memory. User-space will work on the translation.

Adding rules will be slow via iptables, but we can add some quick path
in iptables-restore to open the file once and populate some array that
we can use for fast lookups. Same thing for the conntrack utility.

Does this match with your initiali idea or I'm missing anything?

Regards.
