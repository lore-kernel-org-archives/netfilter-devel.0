From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables: add more test cases and minor bug fixes
Date: Thu, 19 Feb 2015 16:24:27 +0100
Message-ID: <20150219152427.GA3410@salvia>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52398 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbBSPVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 10:21:16 -0500
Content-Disposition: inline
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 19, 2015 at 02:11:16PM +0100, Florian Westphal wrote:
> Will push to master soon if there are no objections.
> iptables-test.py should now be complete enough to replace the old
> iptables-save format "test" files, so I'm going to remove the tests/
> directory as well.

Nice you added more regression test, this will also help us with the
iptables-compat stuff, thanks Florian!
