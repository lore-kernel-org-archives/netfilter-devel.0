From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: h323: Use mod_timer instead of
 set_expect_timeout
Date: Sat, 23 Jul 2016 12:28:09 +0200
Message-ID: <20160723102809.GA3204@salvia>
References: <1469163555-13170-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbcGWK2U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:28:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C394AE7DA2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:28:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B68F9FEFD1
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:28:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB779FAB56
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:28:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469163555-13170-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2016 at 12:59:15PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> It could simplify the codes without any side effect.
> The set_expect_timeout is used to modify the timer expired time.
> It tries to delete timer, and add it again.
> So we could use mod_timer directly.

Applied, thanks.
