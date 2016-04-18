From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: delete tempfile failover in testcases
Date: Mon, 18 Apr 2016 20:32:01 +0200
Message-ID: <20160418183201.GA2803@salvia>
References: <146066322498.28580.12517682150584977759.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37946 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbcDRScJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:32:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E8F2DC1256
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:32:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D45F69D103
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:32:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA3A59D0F0
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:32:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146066322498.28580.12517682150584977759.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 09:47:05PM +0200, Arturo Borrero Gonzalez wrote:
> It seems both Debian/Fedora (and derivates) contains mktemp (from the coreutils
> package) so it makes no sense to have this failover, which looks buggy also.

Applied.
