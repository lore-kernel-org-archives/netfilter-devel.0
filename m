From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] tests/shell/run-tests.sh: execute tests in
 sorted order
Date: Fri, 13 May 2016 11:40:46 +0200
Message-ID: <20160513094046.GD4008@salvia>
References: <146297037318.18781.4519893770358950261.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57393 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbcEMJkv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 05:40:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C9D4E4B0FB
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:40:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AEAE92687E0
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:40:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A47122687E0
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:40:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146297037318.18781.4519893770358950261.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 11, 2016 at 02:39:33PM +0200, Arturo Borrero Gonzalez wrote:
> Let's sort tests files before iterating over them.
> 
> Put the find string in a separated function so it's more readable.

Applied.
