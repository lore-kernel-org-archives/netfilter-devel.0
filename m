From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests: py: allow to run tests with other nft binaries
Date: Wed, 27 Apr 2016 19:25:15 +0200
Message-ID: <20160427172515.GA12569@salvia>
References: <146123183481.8142.11138398894868501284.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42872 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbcD0RZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:25:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5B373842F
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:25:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4D66BA861
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:25:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E4337AD81
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:25:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146123183481.8142.11138398894868501284.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 21, 2016 at 11:43:54AM +0200, Arturo Borrero Gonzalez wrote:
> Allow to run tests with other nft binaries by reading a 'NFT'
> environment variable, allowing arbitrary locations for the nft binary.
> 
> This is what the tests/shell/run-tests.sh script does.
> 
> Among other thing, this allow us to properly hook this testsuite
> from the Debian CI environment (https://ci.debian.net) where we can perform
> tests for packages 'as installed'.

Applied, thanks.
