From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v5 1/3] include: cache ip_tables.h, ip6_tables.h,
 arp_tables.h and ebtables.h
Date: Wed, 13 Jul 2016 11:52:58 +0200
Message-ID: <20160713095258.GA14877@salvia>
References: <20160712200417.21890-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42095 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcGMJxc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jul 2016 05:53:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BB7EFEAA6F
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 11:53:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AB7A8FAB4F
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 11:53:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A5594FAB4F
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 11:52:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160712200417.21890-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 12, 2016 at 10:04:15PM +0200, Pablo M. Bermudo Garay wrote:
> From: Pablo Neira <pablo@netfilter.org>
> 
> The xt over nft support that comes in follow up patches need this, and update
> the corresponding Makefile.am.
> 
> Based on patch from Arturo Borrero Gonzalez.

Applied, thanks.
