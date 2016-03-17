From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: unload modules between tests
Date: Thu, 17 Mar 2016 16:42:51 +0100
Message-ID: <20160317154251.GA5866@salvia>
References: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49751 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964964AbcCQPmz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 11:42:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0FDC513C0DC
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:42:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01967DA385
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:42:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 260DDDA8FB
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:42:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 17, 2016 at 09:34:47AM +0100, Arturo Borrero Gonzalez wrote:
> This patch adjusts the main test script so it unload all nftables
> kernel modules between tests.
> 
> This way we achieve two interesting things:
>  * avoid false errors in some testcases due to module loading order
>  * the module loading/unloading path itself
> 
> The false positives is for example, listing ruleset per families, which depends
> on the loading order of nf_tables_xx modules.
> 
> We can later add more modules to unload incrementally (for
> example nf_tables_switchdev).
> 
> This patch assumes we are working with a kernel which is compiled with
> nf_tables =m, the case using =y is not supported and can still produce false
> positives in some testcases due to module ordering.

Applied, thanks Arturo.
