From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: nft-ipv6: Fix ipv6 flags
Date: Mon, 15 Feb 2016 20:47:07 +0100
Message-ID: <20160215194707.GA8679@salvia>
References: <20160210052200.GA11029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57437 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbcBOTrL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2016 14:47:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 25F4E6C0A
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:47:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 17F2091CB
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:47:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A7FA91D6
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:47:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160210052200.GA11029@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 10, 2016 at 10:52:00AM +0530, Shivani Bhardwaj wrote:
> Replace the flags with the correct ipv6 flags.
> 
> Details:
> Ana found out the bug and submitted the patch, Shivani applied it
> on the latest tree and compile tested it.

Applied, thanks Shivani.
