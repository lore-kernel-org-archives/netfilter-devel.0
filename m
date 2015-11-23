From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nf-next 1/1] netfilter: nft_payload: add packet
 mangling support
Date: Mon, 23 Nov 2015 12:45:40 +0000
Message-ID: <20151123124540.GB20290@macbook.localdomain>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
 <1447078234-21628-2-git-send-email-kaber@trash.net>
 <20151123123115.GA13479@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:43008 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753672AbbKWMpp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 07:45:45 -0500
Content-Disposition: inline
In-Reply-To: <20151123123115.GA13479@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.11, Pablo Neira Ayuso wrote:
> On Mon, Nov 09, 2015 at 02:10:34PM +0000, Patrick McHardy wrote:
> > Add support for mangling packet payload. Checksum for the specified
> > base header is updated automatically, however no double updates (for
> > pseudo headers) are supported, meaning no stateless NAT is supported.
> 
> Patrick, if you have no concerns, I'll pass this to David in the next
> batch.

It needs a minor fix to work with link layer headers. I'll try to get it
ready tonight.
