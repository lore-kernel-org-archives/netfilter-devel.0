From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] ip6tables: Use consistent exit code for EAGAIN
Date: Sun, 3 Nov 2013 22:43:10 +0100
Message-ID: <20131103214310.GA10821@localhost>
References: <1383365314-12290-1-git-send-email-cernekee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab3KCVnT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:43:19 -0500
Content-Disposition: inline
In-Reply-To: <1383365314-12290-1-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 01, 2013 at 09:08:34PM -0700, Kevin Cernekee wrote:
> As of commit 056564f6a (Add new exit value to indicate concurrency
> issues), the IPv4 iptables binary returns exit status 4 to indicate that
> the kernel returned EAGAIN when trying to update a table.  But ip6tables
> still returns exit status 1 under the same circumstances.  Update
> ip6tables to bring it in line with iptables behavior.

Applied, thanks.
