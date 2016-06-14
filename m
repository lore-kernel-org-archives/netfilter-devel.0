From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_cgroup: Add translation to nft
Date: Tue, 14 Jun 2016 18:48:51 +0200
Message-ID: <20160614164851.GA1499@salvia>
References: <20160609195419.GA1677@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbcFNQsz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 12:48:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4E175C2305
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:48:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3F72D9EBB4
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:48:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 290B59EBA0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:48:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160609195419.GA1677@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 09, 2016 at 09:54:22PM +0200, Laura Garcia Liebana wrote:
> Add translation for cgroup to nft. Path parameter not supported in nft
> yet.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m cgroup --cgroup 0 -j ACCEPT
> nft add rule ip filter INPUT meta cgroup 0 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m cgroup ! --cgroup 0 -j ACCEPT
> nft add rule ip filter INPUT meta cgroup != 0 counter accept

Applied, thanks.

Please, document on the wikipage that we don't support yet the new
cgroup2 path-based on nft so we don't forget to discuss about this at
some point.
