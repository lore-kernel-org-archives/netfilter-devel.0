From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] nft: configure.ac: Replace magic dblatex dep.
Date: Fri, 1 Jul 2016 16:15:46 +0200
Message-ID: <20160701141546.GA8164@salvia>
References: <20160625162809.11877-1-nvinson234@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicholas Vinson <nvinson234@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbcGAOQA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 10:16:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 45C191B1DFA
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:15:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34395FAB51
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:15:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3715BA5A9
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:15:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160625162809.11877-1-nvinson234@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 25, 2016 at 09:28:09AM -0700, Nicholas Vinson wrote:
> Add a configure switch to enable and disable PDF document generation.
> This switch is to replace the current method of automatically detecting
> dblatex and building the PDF documentation when present.

I know I mentioned it was better to default this to yes on the
bugzilla report, but I noticed this will just break many existing
automated build infrastructure for everyone that have silently skipped
building this.

So could you reverse the logic? I'd suggest something like:

        --enable-pdf-doc

so the PDF documentation building is disabled by default.

Thanks.
