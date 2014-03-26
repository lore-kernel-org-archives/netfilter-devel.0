From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add meta expression key for bridge
 interface name
Date: Wed, 26 Mar 2014 15:06:25 +0200
Message-ID: <5332D0D1.7010506@linux.intel.com>
References: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20140326121255.GA1375@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24383 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbaCZNG2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:06:28 -0400
In-Reply-To: <20140326121255.GA1375@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

> On Tue, Mar 25, 2014 at 06:39:47PM +0200, Tomasz Bursztyka wrote:
>> NFT_META_IBRIFNAME to get packet input bridge interface name
>> NFT_META_OBRIFNAME to get packet output bridge interface name
> Minor request: NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.
>

Will do

Thanks,

Tomasz
