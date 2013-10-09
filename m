From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: iptables-nftables mnl_nft_batch_talk:: Invalid argument
Date: Wed, 09 Oct 2013 08:01:22 +0300
Message-ID: <5254E322.10308@linux.intel.com>
References: <CAEyr1FTqVgbM3zK-UAL0fHU4MRkYvf-xzNb7Cp7FQT3NQiMgXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Anand Raj Manickam <anandrm@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3JIFBZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:01:25 -0400
In-Reply-To: <CAEyr1FTqVgbM3zK-UAL0fHU4MRkYvf-xzNb7Cp7FQT3NQiMgXQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anand,

You can increase the debug output via iptables/nft-shared.h: just change 
#if 0 to #if 1.

Tomasz
