From: Florian Westphal <fw@strlen.de>
Subject: Implicit flow tables can't be listed
Date: Thu, 16 Jun 2016 12:29:01 +0200
Message-ID: <20160616102901.GA27422@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: nf-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48380 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbcFPK3H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 06:29:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
	(envelope-from <fw@strlen.de>)
	id 1bDUXl-0004Ya-Aq
	for netfilter-devel@vger.kernel.org; Thu, 16 Jun 2016 12:29:01 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft currently can't list implicit flow tables, e.g.:

 nft add rule ip filter forward flow { ip daddr counter }

... will work, and it shows up in

'nft list flow tables' as 'flow table __ft0' (or some other number) but

 nft list flow table filter __ft0
... will error out ('unexpected junk, expecting string').

We can either teach scanner.l that __ft{decstring} is a string,
or force users to always provide a name.

Any preference?

Thanks.
