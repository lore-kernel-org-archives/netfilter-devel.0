From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] xtables-translate: fix issue with quotes
Date: Sat, 23 Jul 2016 12:15:17 +0200
Message-ID: <20160723101517.GA2515@salvia>
References: <20160722154834.1802-1-pablombg@gmail.com>
 <20160722154834.1802-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59777 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcGWKPa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:15:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DEE26E7DA1
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:15:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D1C2BFB467
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:15:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D0A91FAB52
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:15:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160722154834.1802-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2016 at 05:48:34PM +0200, Pablo M. Bermudo Garay wrote:
> Some translations included escaped quotes when they were called from
> nft:

git am /tmp/iptables-2-2-xtables-translate-fix-issue-with-quotes.patch
-s
gApplying: xtables-translate: fix issue with quotes
error: patch failed: extensions/libxt_NFLOG.c:110

This doesn't apply.

You're not working on top of a fresh git repository. Please,
frequently git pull and rebase your work.
