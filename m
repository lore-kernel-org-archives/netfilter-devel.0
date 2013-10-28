From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables-kernel PATCH] netfilter: nftables: Fix sparse endianness
 issue on nft_nat.c
Date: Mon, 28 Oct 2013 12:13:04 +0200
Message-ID: <526E38B0.9000808@linux.intel.com>
References: <1382086853-14251-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20131028094111.GA9725@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29871 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab3J1KNH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:13:07 -0400
In-Reply-To: <20131028094111.GA9725@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

> On Fri, Oct 18, 2013 at 12:00:53PM +0300, Tomasz Bursztyka wrote:
>> +			range.max_addr.ip =
>> +				be32_to_cpup((__be32 *)
>> +					data[priv->sreg_addr_max].data);
> That doesn't seem correct, we don't want to actually switch the byteorder of
> the data. I'd suggest to simply use (__force __be32).

Was sure I messed up with that. Thanks

Tomasz
