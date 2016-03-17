From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libipt_REJECT: Avoid to print the default
 reject with value in the translation
Date: Thu, 17 Mar 2016 16:46:48 +0100
Message-ID: <20160317154648.GC10673@salvia>
References: <20160316222358.GA5106@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030508AbcCQPq4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 11:46:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7C00813C0E7
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6D3CDDA38E
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 12287DA390
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160316222358.GA5106@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 11:24:00PM +0100, Laura Garcia Liebana wrote:
> Avoid to print the reject with value in the translation when the value is the default.
> 
> Before this patch:
> 
> $ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type port-unreachable
> 
> After this patch:
> 
> $ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip filter FORWARD tcp dport 22 counter reject

Applied this too, thanks.
