From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] proto: Add router advertisement and solicitation
 icmp types
Date: Thu, 10 Mar 2016 12:16:08 +0100
Message-ID: <20160310111608.GA8823@salvia>
References: <20160309185304.GA13575@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbcCJLQL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 06:16:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 95C7FC9ED4
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 12:16:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 879BEDA383
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 12:16:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B19B9DA383
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 12:16:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160309185304.GA13575@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 09, 2016 at 07:53:07PM +0100, Laura Garcia Liebana wrote:
> Enable support for router-advertisement and router-solicitation icmp types in nft.
> 
> Example:
> $ sudo nft add rule ip filter input icmp type router-advertisement counter accept
> $ sudo nft add rule ip filter input icmp type router-solicitation counter accept

Applied, thanks Laura.
