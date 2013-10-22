From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: ipset: Use netlink callback dump args only
Date: Tue, 22 Oct 2013 10:23:16 +0200
Message-ID: <20131022082316.GA20742@localhost>
References: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1382089317-24311-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54799 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab3JVIXU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:23:20 -0400
Content-Disposition: inline
In-Reply-To: <1382089317-24311-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 18, 2013 at 11:41:55AM +0200, Jozsef Kadlecsik wrote:
> Instead of cb->data, use callback dump args only and introduce symbolic
> names instead of plain numbers at accessing the argument members.

Applied, thanks Jozsef.
