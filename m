From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fix nft_cmp_fast failure on
 big endian for size < 4
Date: Mon, 14 Apr 2014 10:39:30 +0200
Message-ID: <20140414083930.GA4567@localhost>
References: <1397301477-16204-1-git-send-email-kaber@trash.net>
 <1397301477-16204-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45129 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbaDNIji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:39:38 -0400
Content-Disposition: inline
In-Reply-To: <1397301477-16204-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 12, 2014 at 01:17:57PM +0200, Patrick McHardy wrote:
> nft_cmp_fast is used for equality comparisions of size <= 4. For
> comparisions of size < 4 byte a mask is calculated that is applied to
> both the data from userspace (during initialization) and the register
> value (during runtime). Both values are stored using (in effect) memcpy
> to a memory area that is then interpreted as u32 by nft_cmp_fast.
> 
> This works fine on little endian since smaller types have the same base
> address, however on big endian this is not true and the smaller types
> are interpreted as a big number with trailing zero bytes.
> 
> The mask therefore must not include the lower bytes, but the higher bytes
> on big endian. Add a helper function that does a cpu_to_le32 to switch
> the bytes on big endian. Since we're dealing with a mask of just consequitive
> bits, this works out fine.

Applied and queue up to -stable. Thanks.
