From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests: shell: run-tests.sh: use src/nft binary by
 default
Date: Thu, 23 Jun 2016 19:48:30 +0200
Message-ID: <20160623174830.GA4344@salvia>
References: <146668234418.21827.13311786283737930387.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58128 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbcFWRsf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:48:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0879CE7DA7
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:48:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ECD579EBA1
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:48:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 185259EBA7
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:48:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146668234418.21827.13311786283737930387.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 01:45:44PM +0200, Arturo Borrero Gonzalez wrote:
> Better use the local tree nft binary rather than the installed one.

Applied, thanks Arturo.
