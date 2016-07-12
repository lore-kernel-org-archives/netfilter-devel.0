From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: conntrack: protect early_drop by
 rcu read lock
Date: Tue, 12 Jul 2016 15:01:15 +0200
Message-ID: <20160712130115.GD17163@breakpoint.cc>
References: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Florian Westphal <fw@strlen.de>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40176 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932485AbcGLNBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 09:01:35 -0400
Content-Disposition: inline
In-Reply-To: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> User can add ct entry via nfnetlink(IPCTNL_MSG_CT_NEW), and if the total
> number reach the nf_conntrack_max, we will try to drop some ct entries.
> 
> But in this case(the main function call path is ctnetlink_create_conntrack
> -> nf_conntrack_alloc -> early_drop), rcu_read_lock is not held, so race
> with hash resize will happen.

Right, this was fine before because we held one of the spinlocks which
blocks vs. resize.

