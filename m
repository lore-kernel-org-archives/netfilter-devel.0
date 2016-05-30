From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser: fix crash if we add a chain with an error
 chain type
Date: Mon, 30 May 2016 11:58:39 +0200
Message-ID: <20160530095839.GC20626@salvia>
References: <1464521137-26146-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44122 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbcE3J6p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:58:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9D5F21FE281
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 79D2215D636
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 439B415D636
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464521137-26146-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 29, 2016 at 07:25:37PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> If we add a chain and specify the nonexistent chain type, chain_type_name_lookup
> will return a NULL pointer, and meet the assert condition in xstrdup.
> Fix crash like this:
> 
>   # nft add chain filter input {type none hook input priority 0\;}
>   nft: utils.c:63: xstrdup: Assertion `s != ((void *)0)' failed.
>   Aborted (core dumped)

Applied, thanks.
