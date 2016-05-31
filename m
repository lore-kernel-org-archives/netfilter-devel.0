From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] expr: lookup: give support for inverted matching
Date: Tue, 31 May 2016 13:39:53 +0200
Message-ID: <20160531113953.GB5870@salvia>
References: <146469445364.16345.2121929843145978681.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58829 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbcEaLj6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 07:39:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 23ED8C2B1D
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:39:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 16FD115D64D
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:39:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0871B15D65E
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:39:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146469445364.16345.2121929843145978681.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 01:34:13PM +0200, Arturo Borrero Gonzalez wrote:
> Inverted matching support was included in the kernel, let's give support here
> as well.

Please, update the tests/ file too to check for this new
NFTNL_EXPR_LOOKUP_FLAGS attribute.

Thanks.
