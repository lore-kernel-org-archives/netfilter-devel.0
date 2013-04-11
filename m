From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: ipset: list:set: fix reference counter
 update
Date: Thu, 11 Apr 2013 10:17:16 +0200
Message-ID: <20130411081716.GA3781@localhost>
References: <1365533840-23794-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1365533840-23794-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46781 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3DKIRV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:17:21 -0400
Content-Disposition: inline
In-Reply-To: <1365533840-23794-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 09, 2013 at 08:57:19PM +0200, Jozsef Kadlecsik wrote:
> The last element can be replaced or pushed off and in both
> cases the reference counter must be updated.

Applied, thanks Jozsef.
