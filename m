From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] test/shell/run-tests.sh: also unload NAT modules
Date: Wed, 13 Apr 2016 01:25:09 +0200
Message-ID: <20160412232509.GA21502@salvia>
References: <146010523543.17551.10690033432370786467.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37849 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934AbcDLXZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 19:25:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A649CC9EEA
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:25:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9801DAD87
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:25:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1C3CB505B
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:25:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146010523543.17551.10690033432370786467.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 10:47:15AM +0200, Arturo Borrero Gonzalez wrote:
> Also unload NAT modules between tests.

also applied, thanks.
