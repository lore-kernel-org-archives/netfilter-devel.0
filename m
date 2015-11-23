From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack-tools: add conntrackd.conf(5) manpage
Date: Mon, 23 Nov 2015 16:05:19 +0100
Message-ID: <20151123150519.GA1242@salvia>
References: <144793710566.22054.7165429515812452375.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59906 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbbKWPFc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 10:05:32 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EDC5F18CDC2
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 16:05:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE8E3DA80B
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 16:05:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9EA48DA7FF
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 16:05:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <144793710566.22054.7165429515812452375.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 19, 2015 at 01:46:45PM +0100, Arturo Borrero Gonzalez wrote:
> This new manpage describes all the configuration options of the conntrackd.conf
> file.
> 
> While at it, point conntrackd(8) to this new manpage.

Applied, thanks Arturo.

I added the conntrackd.conf manpage to the Makefile.am so it is
installed through make install.

I have also slightly update the authors area at the bottom of this.
Please, send incremental updates in case you need to refine this.
