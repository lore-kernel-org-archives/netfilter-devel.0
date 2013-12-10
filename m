From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] expr: add support for nfnetlink queue
Date: Tue, 10 Dec 2013 11:03:10 +0100
Message-ID: <20131210100310.GA4780@localhost>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
 <1385809042-20049-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3LJKDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:03:23 -0500
Content-Disposition: inline
In-Reply-To: <1385809042-20049-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 30, 2013 at 11:57:21AM +0100, Eric Leblond wrote:
> This patch adds a support of the queue target.

Applied these two libnftables patches to the next-3.14 branch:

http://git.netfilter.org/libnftables/log/?h=next-3.14

Will merge this to master once 3.13 is out as this feature is
scheduled for 3.14.
