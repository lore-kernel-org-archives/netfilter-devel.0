From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [RFC 0/3] Add support for meta keys, bridge family specific
Date: Thu, 27 Mar 2014 11:19:29 +0200
Message-ID: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53447 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbaC0JTr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:19:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick and Pablo,

I need your input on that one, thus I am sending it as an RFC.

Patch 1 and 2 are straight forward so I'll skip. (though there might be 
improvement to be done. For instance, the init code part is 90% same so
it could be factorized maybe)

Now patch 3: without it, the bridge specific module for meta expression
cannot work: bare meta expression module gets in use since it's generic from
family level.
It's again quite trivial, but I would like your opinion about it.

I was thinking also on different solutions like registering a meta expr type
for every family... but it's not really memory wise.

With patch 3, at worst it loops through the entire expression type list
and this case happens for most of expressions, since they are family agnostic.
So it's not great either...

What do you think?

(Btw, I already made the patches for libnftnl and nftables but I skipped those
for this RFC.)

Tomasz

-- 
1.8.3.2

