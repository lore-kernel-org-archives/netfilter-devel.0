From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] examples: load modules when adding chains or tables
Date: Fri, 29 Apr 2016 12:18:11 +0200
Message-ID: <20160429101811.GA16070@salvia>
References: <1461924454-19498-1-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
To: Daniel Wagner <wagi@monom.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbcD2KSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 06:18:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 33285C1253
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 12:18:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1D949100A68
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 12:18:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34325100A68
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 12:18:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461924454-19498-1-git-send-email-wagi@monom.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 29, 2016 at 12:07:34PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 
> Tell the kernel to load the necessary modules by adding
> the NLM_F_CREATE flag.

Applied, thanks for following up on this.
