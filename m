From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 iptables] connlabel: clarify default config path
Date: Thu, 21 Jul 2016 18:58:36 +0200
Message-ID: <20160721165836.GB11501@salvia>
References: <1469053393-11397-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34718 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbcGUQ6m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 12:58:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 779BC21057D
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:58:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 677E6FAB5C
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:58:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7FCDFAB52
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:58:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469053393-11397-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 21, 2016 at 12:23:13AM +0200, Florian Westphal wrote:
> Pablo suggested to print full config file path for connlabel.conf
> parsing errors.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
