From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] tests/shell/run-tests.sh: print hint about
 testcase being executed
Date: Fri, 13 May 2016 11:40:57 +0200
Message-ID: <20160513094057.GE4008@salvia>
References: <146297037318.18781.4519893770358950261.stgit@nfdev2.cica.es>
 <146297037849.18781.5589442408869588727.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57475 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbcEMJlG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 05:41:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 219A24B0EB
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:41:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DA742687DF
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:41:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 063FA2687DF
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:41:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146297037849.18781.5589442408869588727.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 11, 2016 at 02:39:38PM +0200, Arturo Borrero Gonzalez wrote:
> Print a line with the name of the testcase being executed, and then delete it
> with the result.
> 
> There are tests which may take a long time and its good to know what is doing
> the testsuite.

And also applied this. Thanks.
