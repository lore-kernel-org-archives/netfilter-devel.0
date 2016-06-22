From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-compat: use nft built-in comments
 support
Date: Wed, 22 Jun 2016 20:01:20 +0200
Message-ID: <20160622180120.GA9871@salvia>
References: <20160622170701.3399-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46346 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbcFVSBo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 14:01:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 37F36E8E84
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:01:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1E7E76447B
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:01:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2E292266759
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:01:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160622170701.3399-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 07:07:01PM +0200, Pablo M. Bermudo Garay wrote:
> After this patch, iptables-compat uses nft built-in comments support
> instead of comment match.
> 
> This change simplifies the treatment of comments in nft after load a
> rule set through iptables-compat-restore.

Applied, thanks.
