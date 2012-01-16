From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] ulogd2 patches
Date: Mon, 16 Jan 2012 13:46:50 +0100
Message-ID: <20120116124650.GA13273@1984>
References: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	marty <martinbarrowcliff@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36707 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2APMqx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:46:53 -0500
Content-Disposition: inline
In-Reply-To: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 15, 2012 at 04:04:47PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Here follow two patches which address the MySQL support issues. The first
> one adds the support of stored procedures (which then gives the ability
> to use SQL transactions) and the second one introduces a new plugin to
> provide IPv4 addresses in host order, also for MySQL tables.
> Please consider applying them.

Jozsef, if everybody is happy with this, feel free to push it yourself to
ulogd2 git tree.

Thanks!
