From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: fix missing CTA_NAT_SEQ_UNSPEC
Date: Thu, 11 Dec 2008 22:44:31 +0100
Message-ID: <494189BF.1040701@netfilter.org>
References: <20081210200649.23169.33618.stgit@Decadence> <49410EFF.1020603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48916 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757246AbYLKVon (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:44:43 -0500
In-Reply-To: <49410EFF.1020603@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch fixes an inconsistency in nfnetlink_conntrack.h that
>> I introduced myself. The problem is that CTA_NAT_SEQ_UNSPEC is
>> missing from enum ctattr_natseq. This inconsistency may lead to
>> problems in the message parsing in userspace (if the message
>> contains the CTA_NAT_SEQ_* attributes, of course).
>>
>> This patch breaks backward compatibility, however, the only known
>> client of this code is libnetfilter_conntrack which indeed crashes
>> because it assumes the existence of CTA_NAT_SEQ_UNSPEC to do
>> the parsing.
>>
>> The CTA_NAT_SEQ_* attributes were introduced in 2.6.25.
> 
> Applied, thanks.

Thanks Patrick. This one should go to 2.6.28 as bugfix I think. Do you
plan to pass it to David?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
