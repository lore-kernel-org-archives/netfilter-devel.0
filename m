From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: Add SKPID and SKSID meta keys
Date: Tue, 10 Jun 2014 13:01:15 +0200
Message-ID: <20140610110115.GA9240@localhost>
References: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com>
 <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: Yuxuan Shui <yshuiv7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57293 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaFJLB2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:01:28 -0400
Content-Disposition: inline
In-Reply-To: <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 05, 2014 at 10:19:16PM +0800, Yuxuan Shui wrote:
> Add SKPID and SKSID meta keys so we can implement PID and SID matching
> rules in userspace nft tool.

I would like to have some use case in the patch description that
justifies how this can be useful to everyone.

I don't want add more selectors just because we can make it, they
should allow to perform some useful action.
