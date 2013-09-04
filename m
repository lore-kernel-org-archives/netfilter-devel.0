From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool v2 PATCH 3/4] src: Add priority keyword on base
 chain description
Date: Wed, 4 Sep 2013 12:46:02 +0200
Message-ID: <20130904104602.GC8768@localhost>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1378288222-13182-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56376 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934595Ab3IDKqH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:46:07 -0400
Content-Disposition: inline
In-Reply-To: <1378288222-13182-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 04, 2013 at 12:50:21PM +0300, Tomasz Bursztyka wrote:
> Instead of:
> add chain foo bar { type route hook input 0; }
> 
> it should be now:
> add chain foo bar { type route hook input priority 0; }

Applied, thanks.
