From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nf_conntrack_proto_udplite
Date: Fri, 24 Apr 2009 00:24:26 +0200
Message-ID: <49F0EA9A.3070108@netfilter.org>
References: <200904222106.29497.steven@springl.ukfsn.org> <49F04334.9000905@trash.net> <200904231525.54924.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steven Jan Springl <steven@springl.ukfsn.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54601 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZDWWYh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:24:37 -0400
In-Reply-To: <200904231525.54924.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Steven Jan Springl wrote:
> On Thursday 23 April 2009 11:30:12 Patrick McHardy wrote:
>> Steven Jan Springl wrote:
>>> Hello
>>>
>>> Whilst testing kernel 2.6.30-rc3 I have noticed that when I issue
>>> command:
>>>
>>> modprobe nf_conntrack_proto_udplite
>>>
>>> the following message is produced:
>>>
>>> FATAL: Error inserting nf_conntrack_proto_udplite
>>> (/lib/modules/2.6.30-rc3/kernel/net/netfilter/nf_conntrack_proto_udplite.
>>> ko): Invalid argument
>>>
>>> Is this a kernel bug or have I done something wrong?
>> Thanks for the report, it seems the IPv6 udplite protocol was
>> forgotten during a recent API change.
>>
>> Does this patch help?

We also need it for DCCP. I'm going to send another patch for it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
