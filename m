From: Florian Westphal <fw@strlen.de>
Subject: Re: iptables: add more test cases and minor bug fixes
Date: Thu, 19 Feb 2015 17:49:20 +0100
Message-ID: <20150219164920.GD24297@breakpoint.cc>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59301 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbbBSQtW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 11:49:22 -0500
Content-Disposition: inline
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Will push to master soon if there are no objections.
> iptables-test.py should now be complete enough to replace the old
> iptables-save format "test" files, so I'm going to remove the tests/
> directory as well.

pushed everthing plus/tests/ dir removal, I amended the ip6t_dst change
to not include the unrelated whitspace changes.

Thanks,
Florian
