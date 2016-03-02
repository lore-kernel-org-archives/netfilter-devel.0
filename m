From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: libip6t_mh: Add translation to nft
Date: Wed, 2 Mar 2016 20:02:15 +0100
Message-ID: <20160302190215.GB2838@salvia>
References: <2cf9af3607f9af0ee203060ddbaae655b66a1085.1456080369.git.shivanib134@gmail.com>
 <755537e264168d96942df92fa94329aed502a253.1456080369.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41884 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbcCBTCT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 14:02:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 177FF1BFAAA
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:02:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0918BDA38B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:02:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01920DA383
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:02:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <755537e264168d96942df92fa94329aed502a253.1456080369.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 22, 2016 at 12:23:45AM +0530, Shivani Bhardwaj wrote:
> Add translation for mobility header to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
> nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter accept
> 
> $ sudo ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
> nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept

Also applied, thanks.
