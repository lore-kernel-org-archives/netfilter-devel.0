From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: add new testcases for commit/rollback
Date: Tue, 22 Mar 2016 19:49:55 +0100
Message-ID: <20160322184955.GA6521@salvia>
References: <145830792808.5446.13784125186138242867.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37328 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbcCVSuD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 14:50:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6E9A36EF27
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:50:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 627D6DA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:50:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 89347DA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:50:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145830792808.5446.13784125186138242867.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 18, 2016 at 02:32:08PM +0100, Arturo Borrero Gonzalez wrote:
> New simple testcases for kernel commit/rollback operations.
> 
> * ruleset A is loaded (good ruleset)
> * ruleset B is loaded (bad ruleset): fail is expected
> * ruleset A should remain in the kernel

$ git am nft-tests-shell-add-new-testcases-for-commit-rollback.patch -s
Applying: tests/shell: add new testcases for commit/rollback
patch:50: trailing whitespace.
                ct state new 
patch:51: trailing whitespace.
                tcp dport { 22222} 
patch:52: trailing whitespace.
                ip saddr @t drop 
patch:53: trailing whitespace.
                jump other 
patch:123: trailing whitespace.
                ct state new 
warning: squelched 15 whitespace errors
warning: 20 lines add whitespace errors.

I guess you're getting this from the output of nft, but this generates
a bit of noise in git when trying to apply this.

Could you have a look and resubmit? Thanks.
