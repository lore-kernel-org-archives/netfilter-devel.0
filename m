From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/6] ipset patches
Date: Wed, 07 Sep 2011 16:39:29 +0200
Message-ID: <4E678221.2080409@trash.net>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu> <20110907093230.GB9078@1984> <alpine.DEB.2.00.1109071402380.12167@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62683 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab1IGRG2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:06:28 -0400
In-Reply-To: <alpine.DEB.2.00.1109071402380.12167@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.09.2011 14:04, Jozsef Kadlecsik wrote:
> On Wed, 7 Sep 2011, Pablo Neira Ayuso wrote:
> 
>> On Tue, Sep 06, 2011 at 09:59:01PM +0200, Jozsef Kadlecsik wrote:
>>> Hi Patrick and Pablo,
>>>
>>> Here follows the patches which brings the kernel sync with ipset 6.9.1.
>>> The first two are important bugfixes. Please consider applying them.
>>
>> AFAIK, all trees are frozen in master.kernel.org due to the security
>> issue. It seems we'll have to wait until we can apply these patches.
> 
> Yeah, I know. But with the new ipset release it seemed best to send the 
> patches anyway and wait for the cleaning up and verifications at 
> kernel.org.

I think for now I'll apply all patches to my local tree and will either
push them out to kernel.org in case it is available again during the
next days or temporarily move the tree to somewhere else.
