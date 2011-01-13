From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Thu, 13 Jan 2011 20:00:44 +0100
Message-ID: <4D2F4BDC.6060506@trash.net>
References: <20110113123030.3407.59986.stgit@decadence> <4D2F1D07.9090301@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50119 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab1AMTAq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:00:46 -0500
In-Reply-To: <4D2F1D07.9090301@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.01.2011 16:40, schrieb Pablo Neira Ayuso:
> On 13/01/11 13:30, Pablo Neira Ayuso wrote:
>> This patch adds flow-based timestamping for conntracks. This
>> conntrack extension is disabled by default. Basically, we use
>> two 64-bits variables to store the creation timestamp once the
>> conntrack has been confirmed and the other to store the deletion
>> time.
> 
> Sorry, this patch does not apply, I'll fix it and will resend.
> 

Perhaps its best to wait until I've pulled in your tree since
this will likely cause more conflicts. I should get to this
tonight or tommorrow morning.
