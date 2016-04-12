From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3] src/evaluate.c: improve rule management checks
Date: Wed, 13 Apr 2016 01:11:18 +0200
Message-ID: <20160412231118.GA20783@salvia>
References: <146045423317.18092.10497374259960545713.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37111 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523AbcDLXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 19:11:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3547EC9EE1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:11:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C06A1B3065
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:11:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 612371B3009
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:11:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146045423317.18092.10497374259960545713.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2016 at 11:44:17AM +0200, Arturo Borrero Gonzalez wrote:
> Improve checks (and error reporting) for basic rule management operations.
> This includes a fix for netfilter bug #965.

Applied, thanks.

Please, stick to the subject line that we've been using for a while,
for consistency, eg.

        evaluate: improve rule management checks

Thanks for your help.
