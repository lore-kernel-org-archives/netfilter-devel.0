From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH v2] src: add specific byteorder to the struct
 proto_hdr_template
Date: Wed, 17 Sep 2014 09:24:50 +0200
Message-ID: <20140917072450.GA6690@acer.localdomain>
References: <1410278479-25864-1-git-send-email-alvaroneay@gmail.com>
 <1410870079-11421-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53396 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaIQHYy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:24:54 -0400
Content-Disposition: inline
In-Reply-To: <1410870079-11421-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 16, 2014 at 02:21:19PM +0200, Alvaro Neira Ayuso wrote:
> If we try to add a rule like:
> 
> nft add rule filter input udp length {55-9999}
> 
> nftable shows:
> 
> BUG: invalid byte order conversion 0 => 2
> nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' failed.
> 
> Some of the existing payload fields rely on BYTEORDER_INVALID. Therefore, if we
> try to convert it in evaluation step, we hit this bug.
> 
> This patch allows to add a specific byteorder to the struct proto_hdr_template. If
> we create a expression with a invalid byteorder, we will use the byteorder
> added to the proto_hdr_template structure.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [Changes in v2]
> * Use host endian byteorder in the ether saddr/daddr rules.
> 
> [Tested with the rules]
> nft add rule ip filter input ip length 10-55 counter
> nft add rule ip filter input ip length 55-1000 counter
> nft add rule ip filter input udp length {0-100} udp dport 9999 counter
> nft add rule ip filter input udp length {100-9999} udp dport 9999 counter
> nft add rule bridge filter input ether type 0x0800 counter
> nft add rule bridge filter input ether saddr 12:34:56:78.9a:bc counter
> nft add rule bridge filter input ether daddr 12:34:56:78:9a:bc counter
> Tested with the Ana Rey's tests

Applied, thanks Alvaro.
