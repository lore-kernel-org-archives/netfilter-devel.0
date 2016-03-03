From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] tests/listing: add some listing tests
Date: Thu, 3 Mar 2016 20:00:06 +0100
Message-ID: <20160303190006.GC4107@salvia>
References: <145270955304.16020.15628702903369123172.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44435 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbcCCTAY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 14:00:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A4C754B112
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 20:00:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 86478DA385
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 20:00:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 235A8DA396
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 20:00:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145270955304.16020.15628702903369123172.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 07:29:09PM +0100, Arturo Borrero Gonzalez wrote:
> Let's test what is shown with the 'list' command, for ruleset, tables and sets.
> 
> In order to ease debug in case of failure, if the diff tool is in the system,
> then a textual diff is printed.

Applied, thanks Arturo.
