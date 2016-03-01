From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_MASQUERADE: Add translation to nft
Date: Tue, 1 Mar 2016 20:06:38 +0100
Message-ID: <20160301190638.GA2018@salvia>
References: <20160301183547.GA12993@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbcCATGn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 14:06:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BE20BC108F
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:06:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AE604DA38B
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:06:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ACD6FDA38B
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:06:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301183547.GA12993@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 12:05:47AM +0530, Shivani Bhardwaj wrote:
> Add translation for target masquerade to nftables.
> Full translation of this target awaits the support for --to-ports
> option.

Just sent the patch to support this.

Could you add translation for that and send a v2? Thanks.
