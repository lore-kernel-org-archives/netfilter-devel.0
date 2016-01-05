From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4] rule: don't list anonymous sets
Date: Tue, 5 Jan 2016 12:19:23 +0100
Message-ID: <20160105111923.GA8791@salvia>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38699 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbcAELTc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:19:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6FFF51324D6
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:19:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 62282DA804
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:19:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8BCCFDA811
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:19:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 01:18:26PM +0100, Arturo Borrero Gonzalez wrote:
> Don't list anonymous sets when listing all sets.

Applied, thanks Arturo.
