From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] deleting chains and verdict map entries in the same
 transaction
Date: Tue, 8 Sep 2015 12:46:31 +0200
Message-ID: <20150908104631.GB3879@salvia>
References: <1697265942.3578653.1441619142130.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbbIHKkE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 06:40:04 -0400
Content-Disposition: inline
In-Reply-To: <1697265942.3578653.1441619142130.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 07, 2015 at 11:45:42AM +0200, Andreas Schultz wrote:
> Hi,
> 
> I'm trying to delete a verdict map entry and the chain it points to
> in the same nft transaction. This currently fails with:
> 
>    Error: Could not process rule: Device or resource busy
> 
> existing rules:
> 
>  nft list table mangle
> table ip mangle {
> 	map client_to_any { 
> 		type mark : verdict
> 		elements = { 0x00000080 : jump BIn_1, 0x00000100 : jump BIn_2}
> 	}
> 
> 	map any_to_client { 
> 		type mark : verdict
> 		elements = { 0x00000100 : jump BOut_2, 0x00000080 : jump BOut_1}
> 	}
> 
> ...
> 
> 	chain BIn_1 {
> 		counter packets 133 bytes 63243 
> 	}
> 
> 	chain BOut_1 {
> 		counter packets 136 bytes 34430 
> 	}
> }
> 
> delete script:
> 
> # cat /tmp/nft-18536-delete-1.tmp  
> delete element mangle client_to_any { 0x00000080 : jump BIn_1 }
> delete element mangle any_to_client { 0x00000080 : jump BOut_1 }
> delete chain ip mangle BIn_1
> delete chain ip mangle BOut_1
> 
> Result:
> 
> # nft -f  /tmp/nft-18536-delete-1.tmp 
> /tmp/nft-18536-delete-1.tmp:3:1-29: Error: Could not process rule: Device or resource busy
> delete chain ip mangle BIn_1
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> /tmp/nft-18536-delete-1.tmp:4:1-30: Error: Could not process rule: Device or resource busy
> delete chain ip mangle BOut_1
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 
> nft is from git://git.netfilter.org/nftables @ cba42084057b6de61d95d87177f0f8c01db539ab (HEAD)
> kernel is 4.2.0-rc6 with net-next applied from Aug 18th)
> 
> Does it make sense to update to a newer kernel (4.2-final or current net-next) or is this
> expected behavior?

The kernel should allow this.

Will be sending patches for this soon. Will you have some time to
test? If so I would be glad to add your Tested-by: tag to the patch.
