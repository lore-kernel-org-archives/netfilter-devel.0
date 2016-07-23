From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: connlabels: move set helper to
 xt_connlabel
Date: Sat, 23 Jul 2016 12:27:31 +0200
Message-ID: <20160723102731.GB3162@salvia>
References: <1469098277-1227-1-git-send-email-fw@strlen.de>
 <1469098277-1227-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60676 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbcGWK1g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:27:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3AF9DE7DA2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:27:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2E1BDFAB59
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:27:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 463659D5BE
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:27:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469098277-1227-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 21, 2016 at 12:51:17PM +0200, Florian Westphal wrote:
> xt_connlabel is the only user so move it.

Also applied, thanks.
