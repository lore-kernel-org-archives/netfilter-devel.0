From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 0/5] Add suport for bridge if dev name meta exepression
 keys
Date: Thu, 27 Mar 2014 15:11:39 +0200
Message-ID: <5334238B.1010108@linux.intel.com>
References: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20140327125532.GA30825@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51447 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaC0NNJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:13:09 -0400
In-Reply-To: <20140327125532.GA30825@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

> On Thu, Mar 27, 2014 at 02:47:02PM +0200, Tomasz Bursztyka wrote:
>> Here is the patch-set to add meta keys NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.
>>
>> I did not factorize nft_meta.c code to reuse nft_meta_select_ops() and nft_meta_bridge_init()
>> At least solutions I had made the code too ugly.
>> Declaring a type for select_ops functions, same for validate_get() one, and have
>> an in-between functions called relevantly by meta_<bridge_>init etc...
> Thanks. The patches look fine, however I'd ask you to hold off until
> tommorrow. I have patches coming up that will introduce variable sized
> registers for concatenations, which remove some of the functions you
> export, so we can avoid some churn of first exporting, then removing
> them again by adding your patches on top. Should only be very minor
> changes to adapt.

Sure, I will rebase my patchset once your modifications are upstream.

Tomasz
