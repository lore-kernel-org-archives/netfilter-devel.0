From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_pkttype: Add translation to nft
Date: Fri, 25 Dec 2015 13:15:10 +0100
Message-ID: <20151225121510.GC4822@salvia>
References: <20151223173024.GA2450@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46837 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLYMPO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:15:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BEE257B550
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:15:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B135FDA807
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:15:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3485BDA80B
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:15:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223173024.GA2450@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 11:00:25PM +0530, Shivani Bhardwaj wrote:
> +static const struct pkttypes supported_types_xlate[] = {
> +	{"unicast", PACKET_HOST, 1, "to us"},
> +	{"broadcast", PACKET_BROADCAST, 1, "to all"},
> +	{"multicast", PACKET_MULTICAST, 1, "to group"},
                                        ^^^^^^^^^^^^^

Do we need these fields?
