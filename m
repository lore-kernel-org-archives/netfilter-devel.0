From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_rt.c: Add translation to nft
Date: Mon, 7 Mar 2016 19:02:12 +0100
Message-ID: <20160307180212.GA6385@salvia>
References: <20160306152657.GA2680@janani-Inspiron-3521>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Janani Ravichandran <janani.rvchndrn@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53998 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbcCGSCQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:02:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A93FA73FA
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:02:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 992BEDA3A3
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:02:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 18886DA8FB
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:02:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160306152657.GA2680@janani-Inspiron-3521>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 06, 2016 at 10:26:57AM -0500, Janani Ravichandran wrote:
> Add translation for rt for options --rt-type, --rt-segsleft and --rt-len.
> 
> Examples:
> 
> $ sudo ip6tables-translate -A INPUT -m rt --rt-type 0 -j DROP
> nft add rule ip6 filter INPUT rt type 0 counter drop
> 
> $ sudo ip6tables-translate -A INPUT -m rt ! --rt-len 22 -j DROP
> nft add rule ip6 filter INPUT rt hdrlength != 22 counter drop
> 
> $ sudo ip6tables-translate -A INPUT -m rt --rt-segsleft 26 -j ACCEPT
> nft add rule ip6 filter INPUT rt seg-left 26 counter accept
> 
> The xlate function returns 0 for other options.

Applied, thanks Janani.

