From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nft: Remove memory-leak
Date: Tue, 15 Mar 2016 12:26:42 +0100
Message-ID: <20160315112642.GA3081@salvia>
References: <20160315030741.GA3900@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59862 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbcCOL0y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 07:26:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C06F080B06
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:26:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B033EDA383
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:26:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D272CDA390
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:26:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160315030741.GA3900@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 08:37:41AM +0530, Piyush Pangtey wrote:
> Added matching xfree calls in chain_free(), for the chain members 'type' and
> 'dev'.

Applied, thanks Piyush.
