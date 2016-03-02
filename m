From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] iptables: nft-ipv6: Use meta l4proto instead of
 nexthdr
Date: Wed, 2 Mar 2016 20:02:06 +0100
Message-ID: <20160302190206.GA2838@salvia>
References: <2cf9af3607f9af0ee203060ddbaae655b66a1085.1456080369.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbcCBTCK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 14:02:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1AB1715AEA0
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:02:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0A562DA380
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:02:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 03C77DA386
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:02:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <2cf9af3607f9af0ee203060ddbaae655b66a1085.1456080369.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 22, 2016 at 12:22:48AM +0530, Shivani Bhardwaj wrote:
> Use meta l4proto in place of nexthdr for ipv6 protocols as it is not
> necessary that all protocols be next header.

Applied, thanks Shivani.

