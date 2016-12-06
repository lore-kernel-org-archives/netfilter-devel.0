From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [bug report] netfilter: nft_payload: layer 4 checksum adjustment
 for pseudoheader fields
Date: Tue, 6 Dec 2016 13:16:08 +0100
Message-ID: <20161206121608.GA1987@salvia>
References: <20161206115734.GA30548@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49560 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbcLFMQP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 07:16:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25322A4179
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:16:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 154C6DA85F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:16:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEE77DA86F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:16:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161206115734.GA30548@elgon.mountain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 06, 2016 at 02:57:34PM +0300, Dan Carpenter wrote:
> Hello Pablo Neira Ayuso,
> 
> The patch 556c291b3a1b: "netfilter: nft_payload: layer 4 checksum
> adjustment for pseudoheader fields" from Nov 24, 2016, leads to the
> following static checker warning:
> 
> 	net/netfilter/nft_payload.c:301 nft_payload_set_eval()
> 	error: uninitialized symbol 'fsum'.

This should restrict this case you're reporting here:

http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/commit/?id=a3c91a548b9b9f05f81e7bfe7fec3544a376269a

Otherwise let me know, thanks.
