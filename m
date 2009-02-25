From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 25 Feb 2009 10:42:55 +0100
Message-ID: <49A5129F.3000700@netfilter.org>
References: <20090223101354.7104.45999.stgit@Decadence> <49A3FA4B.5000107@trash.net> <49A3FE90.50305@netfilter.org> <49A3FEE2.3000601@trash.net> <49A47F2B.6040704@netfilter.org> <49A4DC95.8090708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39452 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751736AbZBYJnL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:43:11 -0500
In-Reply-To: <49A4DC95.8090708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>>> In case you agree, I also think "secret" would be a more fitting name.
>>
>> I can rename the field to "secret" in the structure or change the
>> iptables cluster match option to be "--cluster-secret" instead of
>> "--cluster-hash-seed" if you like.
> 
> Its more fitting in my opinion, but I don't really care.

I don't either, would you apply the patch as is now?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
