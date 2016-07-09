From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] xtables-translate: fix multiple spaces issue
Date: Sat, 9 Jul 2016 13:41:00 +0200
Message-ID: <20160709114100.GD1357@salvia>
References: <20160709102751.3792-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45654 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbcGILlF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2016 07:41:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B5608C9EC5
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:41:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A79DA6446A
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:41:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C5287A8E9
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:41:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160709102751.3792-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 09, 2016 at 12:27:51PM +0200, Pablo M. Bermudo Garay wrote:
> This patch fixes a multiple spaces issue. The problem arises when a rule
> set loaded through iptables-compat-restore is listed in nft.

Applied, thanks.
