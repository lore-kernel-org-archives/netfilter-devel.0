From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/6] netfilter: ipset: Fix "may be used uninitialized"
 warnings
Date: Thu, 2 May 2013 12:09:07 +0200
Message-ID: <20130502100907.GD3432@localhost>
References: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1367487442-3571-6-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34215 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3EBKJL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 May 2013 06:09:11 -0400
Content-Disposition: inline
In-Reply-To: <1367487442-3571-6-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 02, 2013 at 11:37:21AM +0200, Jozsef Kadlecsik wrote:
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Same thing here, include warning message from gcc.
