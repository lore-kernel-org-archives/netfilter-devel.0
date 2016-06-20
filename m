From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] configure: Fix flex version check
Date: Mon, 20 Jun 2016 11:45:05 +0200
Message-ID: <20160620094505.GA1735@salvia>
References: <1466191063-25552-1-git-send-email-shivanib134@gmail.com>
 <20160618124245.GA13901@salvia>
 <CAKHNQQHpZHTxmPnZjc6jBasnUrFHLQdi-WqmCP-e7TMC1uihaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60741 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbcFTJ4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 05:56:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E38CB1682E3
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 11:45:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D3E279EBC1
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 11:45:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A46F69EBC1
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 11:45:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAKHNQQHpZHTxmPnZjc6jBasnUrFHLQdi-WqmCP-e7TMC1uihaQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 18, 2016 at 10:19:51PM +0530, Shivani Bhardwaj wrote:
> Hi Pablo,
> 
> Just to avoid any confusion, should I be following up with patches for
> iptables and conntrack-tools to completely remove this check? It is
> already not there in nft. Please let me know.

Yes, please remove this check. So just check for 'flex' with no
specific version as in nft. Thanks!
