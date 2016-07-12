From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: conntrack: protect early_drop by
 rcu read lock
Date: Tue, 12 Jul 2016 16:34:16 +0200
Message-ID: <20160712143416.GA3717@salvia>
References: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Florian Westphal <fw@strlen.de>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57917 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbcGLOe1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 10:34:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3B7E0392E06
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 16:34:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 29D48FF154
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 16:34:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3A7A7FAB46
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 16:34:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 12, 2016 at 07:45:00PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> User can add ct entry via nfnetlink(IPCTNL_MSG_CT_NEW), and if the total
> number reach the nf_conntrack_max, we will try to drop some ct entries.
> 
> But in this case(the main function call path is ctnetlink_create_conntrack
> -> nf_conntrack_alloc -> early_drop), rcu_read_lock is not held, so race
> with hash resize will happen.

Applied, thanks.
