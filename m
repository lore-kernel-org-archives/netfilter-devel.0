From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] nfacct: add timestamp option
Date: Fri, 3 Aug 2012 11:35:33 +0200
Message-ID: <20120803093533.GE12107@1984>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
 <1343856436-11129-6-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56000 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2HCJfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:35:36 -0400
Content-Disposition: inline
In-Reply-To: <1343856436-11129-6-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 01, 2012 at 11:27:16PM +0200, Eric Leblond wrote:
> This patch adds a timestamp option to the nfacct plugin.
> If activated, nfacct output a timestamp which is computed just
> after sending the nfacct request.

I think it makes sense to make it unconditionally.

The dump of the counters without the time doesn't make too much sense
to me?

Let me know.
