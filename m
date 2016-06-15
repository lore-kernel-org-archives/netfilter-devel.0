From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: delete unused variable in run-tests.sh
Date: Wed, 15 Jun 2016 14:02:41 +0200
Message-ID: <20160615120241.GA1894@salvia>
References: <146564035699.7164.17539179584212489576.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbcFOMCt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 08:02:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6EBEBE5A41
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:02:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5EF029EBAF
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:02:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D60DC9EBB5
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:02:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146564035699.7164.17539179584212489576.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 11, 2016 at 12:19:17PM +0200, Arturo Borrero Gonzalez wrote:
> This ${TESTS_OUTPUT} variable is empty. Delete it.
> 
> It was probably an idea about dinamically redirecting testscases output.

Applied, thanks.
