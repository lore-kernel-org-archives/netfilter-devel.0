From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] pgsql schema: fix timestamp default value
Date: Fri, 3 Aug 2012 11:29:15 +0200
Message-ID: <20120803092915.GC12107@1984>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
 <1343856436-11129-4-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2HCJ3V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:29:21 -0400
Content-Disposition: inline
In-Reply-To: <1343856436-11129-4-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 01, 2012 at 11:27:14PM +0200, Eric Leblond wrote:
> Set timestamp default value to now() not now which is the time at
> table creation.
> 
> Reported-by: Mr Dash Four

Applied, thanks.
