From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH v3 1/2] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Tue, 18 Jun 2013 07:50:14 +0300
Message-ID: <51BFE706.6010109@linux.intel.com>
References: <20130617092600.2814.15883.stgit@localhost> <51BEE134.5010406@linux.intel.com> <CAFpD06T49mEBTQHey2CungHn5ew-ohgaSOAZyai2EzsSSqJ5CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51519 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab3FREug (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:50:36 -0400
In-Reply-To: <CAFpD06T49mEBTQHey2CungHn5ew-ohgaSOAZyai2EzsSSqJ5CA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

>> I guess you don't want to continue looping after you found your chain. On
>> success, make it break.
> Looking the code, in other functions like nft_chain_user_del,
> i guess that the loop continue after found the chain.
> Am i wrong?

Looks like you found an optimization patch to make in that function.

>> And on error your function should return the error code.
> return ret == 0 ? 1 : 0;
> is it ok this code?
>

Sound fine to me in that particular case.


Tomasz

