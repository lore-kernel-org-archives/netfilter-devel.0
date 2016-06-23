From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] expr: lookup: give support for inverted
 matching
Date: Thu, 23 Jun 2016 19:47:10 +0200
Message-ID: <20160623174710.GA4031@salvia>
References: <146469610712.22148.15640593727383542091.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57982 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbcFWRrR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:47:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4CD28E7DA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:47:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3C3839EBAD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:47:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 379249EBAD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:47:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146469610712.22148.15640593727383542091.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 02:03:10PM +0200, Arturo Borrero Gonzalez wrote:
> Inverted matching support was included in the kernel, let's give support here
> as well.

$ git am tmp/libnftnl-v2-expr-lookup-give-support-for-inverted-matching.patch -s
Applying: expr: lookup: give support for inverted matching
error: patch failed: tests/nft-expr_lookup-test.c:42
error: tests/nft-expr_lookup-test.c: patch does not apply
Patch failed at 0001 expr: lookup: give support for inverted matching
The copy of the patch that failed is found in:
   patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am
--abort".

This doesn't apply :(

Please resubmit.
