From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxt_iprange: remove extra space in translation
Date: Wed, 22 Jun 2016 19:57:26 +0200
Message-ID: <20160622175726.GA9191@salvia>
References: <20160620102456.31875-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45712 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbcFVR5f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:57:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A239BE8E90
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:57:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91B7CFAB4E
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:57:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91F8ACA0FF
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:57:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160620102456.31875-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2016 at 12:24:56PM +0200, Pablo M. Bermudo Garay wrote:
> Extra space was printed by iprange_xlate:
> 
>   # iptables-translate -A INPUT -m iprange --src-range \
>     192.168.25.149-192.168.25.151 -j ACCEPT
> 
>   nft add rule ip filter INPUT  ip saddr 192.168.25.149-192.168.25...
>                               ^^

Applied, thanks.
