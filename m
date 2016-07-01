From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] extensions: added AR substitution
Date: Fri, 1 Jul 2016 16:31:58 +0200
Message-ID: <20160701143158.GA20187@salvia>
References: <20160624191845.4660-1-jordan@yelloz.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jordan Yelloz <jordan@yelloz.me>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33284 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbcGAOcC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 10:32:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 586291B1DFE
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:32:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 48F40FAB4E
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:32:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 46F3F266752
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:31:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160624191845.4660-1-jordan@yelloz.me>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 24, 2016 at 12:18:45PM -0700, Jordan Yelloz wrote:
> This is to ensure that the correct AR is run in cross-compile jobs.
> Often a cross-compile build will succeed without this change but it
> fails on my Gentoo Linux system when I have binutils installed with the
> "multitarget" USE flag.
> This change substitues AR with the autotools-supplied AR for the
> extensions subdirectory.

Applied, thanks.
