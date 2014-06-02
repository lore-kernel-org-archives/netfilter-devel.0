From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: add optional [seconds] argument to -w
Date: Mon, 2 Jun 2014 12:05:21 +0200
Message-ID: <20140602100521.GA15386@localhost>
References: <1400778571-1482-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45260 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaFBKF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:05:29 -0400
Content-Disposition: inline
In-Reply-To: <1400778571-1482-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 22, 2014 at 07:09:31PM +0200, Jiri Popelka wrote:
> This patch adds an optional numeric argument
> to -w option which can be used to specify
> how long to wait for an exclusive lock.
> 
> If the value isn't specified it works as before,
> i.e. program waits indefinitely.
> 
> If user specifies it, program exits after
> the given time interval passes.

No major objections to this, only one change: Please, adapt the
nftables compat code so the parser doesn't complain if someone passes
-w value.

Thanks.
