From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [libnetfilter_log PATCH 2/3] Convert kernel to stdint types
Date: Tue, 16 Jun 2015 21:22:42 +0200
Message-ID: <20150616192241.GA3229@euler>
References: <20150516113828.GR14201@euler>
 <20150527122249.GB17945@salvia>
 <20150614184351.GA24373@euler>
 <20150616164722.GA8999@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:43802 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbbFPTXG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 15:23:06 -0400
Content-Disposition: inline
In-Reply-To: <20150616164722.GA8999@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
[..]
> > Thanks for your review and pushing of patches so far!
> 
> Thanks for confirming and for the rather large patchset to address the
> musl problems.

Sorry for the spam...

Now everything non-historical on netfilter.org builds fine except for:
- ulogd2 (patches have not been applied yet)
- libnetfilter_queue (small oversight of mine, patch will follow)
- nft-sync (not tested before, patch will follow)
- iptables (previous patches solve only some problems, more patches
    will follow)
- libnl-nft (is this still in use?)
- conntrack rpc helper (musl lacks rpc headers, I would like to add a
    configure test to make it conditional on the presence of rpc headers)

Felix
