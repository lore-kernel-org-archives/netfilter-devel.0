From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] bugfixes for nf-next-2.6 (2.6.38-rc)
Date: Tue, 01 Feb 2011 13:47:56 +0100
Message-ID: <4D4800FC.7070901@netfilter.org>
References: <20110201120116.3427.96097.stgit@decadence> <4D480066.5000402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40510 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab1BAMr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:47:59 -0500
In-Reply-To: <4D480066.5000402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/02/11 13:45, Patrick McHardy wrote:
> Am 01.02.2011 13:05, schrieb Pablo Neira Ayuso:
>> Hi Patrick!
>>
>> I've got a couple of patches for nf-next-2.6. The first fixes
>> arptables that seems to be broken since quite some time due
>> to a broken cleanup. The latter refers to the CT event filtering,
>> I think it can be qualified as bugfix since the current filtering
>> schema is not useful for conntrackd.
> 
> The subject is contradictional, nf-next-2.6/net-next-2.6 will be
> merged once 2.6.38 is released, not for 2.6.38-rc. I suppose these
> fixes should go into nf-2.6.git for 2.6.38-rc?

Indeed, I think this should go to nf-2.6.git for 2.6.38-rc. Sorry!
