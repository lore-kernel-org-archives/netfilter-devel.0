From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] comment: Add translation to nft
Date: Mon, 29 Feb 2016 13:34:57 +0100
Message-ID: <20160229123457.GA15356@salvia>
References: <20160223194934.GA19483@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55368 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbcB2MfE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:35:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1FBF64B9E5
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:35:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DB7DDA8F8
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:35:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DBD63DA38C
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:34:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160223194934.GA19483@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 24, 2016 at 01:19:34AM +0530, Shivani Bhardwaj wrote:
> Add translation for match comment to nftables.
> This patch also adds the relevant infrastructure for carrying out
> the translation.
> 
> Example:
> 
> $ sudo iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
> nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"

Applied with some changes, see final commit pushed upstream for updates.

Thanks.
