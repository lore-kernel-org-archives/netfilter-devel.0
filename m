From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] netfilter: nft_payload: layer 4 checksum adjustment
 for pseudoheader fields
Date: Tue, 6 Dec 2016 15:24:53 +0300
Message-ID: <20161206122453.GH8244@mwanda>
References: <20161206115734.GA30548@elgon.mountain>
 <20161206121608.GA1987@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39898 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbcLFMZE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 07:25:04 -0500
Content-Disposition: inline
In-Reply-To: <20161206121608.GA1987@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 06, 2016 at 01:16:08PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Dec 06, 2016 at 02:57:34PM +0300, Dan Carpenter wrote:
> > Hello Pablo Neira Ayuso,
> > 
> > The patch 556c291b3a1b: "netfilter: nft_payload: layer 4 checksum
> > adjustment for pseudoheader fields" from Nov 24, 2016, leads to the
> > following static checker warning:
> > 
> > 	net/netfilter/nft_payload.c:301 nft_payload_set_eval()
> > 	error: uninitialized symbol 'fsum'.
> 
> This should restrict this case you're reporting here:
> 
> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/commit/?id=a3c91a548b9b9f05f81e7bfe7fec3544a376269a
> 
> Otherwise let me know, thanks.

That works...  Seems like it would have been easier to just move it
under the if statement though...

regards,
dan carpenter

