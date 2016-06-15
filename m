From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: cleanup tempfile handling in
 testcases/sets/cache_handling_0
Date: Wed, 15 Jun 2016 14:02:50 +0200
Message-ID: <20160615120250.GB1894@salvia>
References: <146564075890.10180.12129365273166621494.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370AbcFOMC7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 08:02:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4A850E5A40
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:02:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 39CDD64485
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:02:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6E2079EBC1
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:02:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146564075890.10180.12129365273166621494.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 11, 2016 at 12:25:59PM +0200, Arturo Borrero Gonzalez wrote:
> It uses a bogus pattern which was cleaned up already in others testscases,
> and this is a leftover.

Also applied, thanks.
