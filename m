From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] netfilter: nf_tables: add hash expression
Date: Fri, 12 Aug 2016 12:35:21 +0200
Message-ID: <20160812103521.GA3537@salvia>
References: <20160811160203.GA27819@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33040 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbcHLKf0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:35:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B135AD1638
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:35:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A15B4FF134
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:35:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 952A79EBC8
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:35:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160811160203.GA27819@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 11, 2016 at 06:02:07PM +0200, Laura Garcia Liebana wrote:
> This patch adds a new hash expression, this provides jhash support but
> this can be extended to support for other hash functions.
> 
> The modulus and seed already comes embedded into this new expression.
> 
> Use case example:
> meta mark set hash ip saddr mod 10

Applied, thanks Laura.
