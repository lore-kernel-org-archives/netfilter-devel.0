From: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Subject: [PATCHv2] ebtables: Cache a copy of the v3.16 kernel headers in the
 ebtables tree
Date: Thu, 26 Feb 2015 22:45:46 +0000
Message-ID: <54EFA21A.5090507@codethink.co.uk>
References: <54EF4BE4.4020002@codethink.co.uk> <20150226193054.GA5142@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:49305 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbbBZWpu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 17:45:50 -0500
In-Reply-To: <20150226193054.GA5142@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26/02/15 19:30, Pablo Neira Ayuso wrote:
> On Thu, Feb 26, 2015 at 04:37:56PM +0000, Pedro Alvarez wrote:
>>
>> I decided to go for 2, and here is the patch:
>
> Yes, we have to go 2 as we did in iptables.
>
>>    Repo: git://git.baserock.org/delta/ebtables.git
>>    Branch: baserock/pedroalvarez/ebt_ulog-fix
>>    Sha1: 13747a56890cc710b2b4d420edc03a6c2714f40e
>>
>> NOTE: I didn't want to send a diff, since it would be big and nonsense, but I
>> can do that if needed.
>
> OK, but it should be sufficient to include netfilter_bridge headers
> for each supported extension, including types.h and filter.h as we do
> in iptables.

Hi Pablo, thanks for taking a look at my patch.

Yeah, you are right, here is the second version of the patch [1] 
following your suggestion.

Repo: git://git.baserock.org/delta/ebtables.git
Branch: baserock/pedroalvarez/ebt_ulog-fix-v2
Sha1: 04d387f29184907dd61f7e6b23b0dd9ef3913c50


[1]: 
http://git.baserock.org/cgi-bin/cgit.cgi/delta/ebtables.git/commit/?h=baserock/pedroalvarez/ebt_ulog-fix-v2&id=04d387f29184907dd61f7e6b23b0dd9ef3913c50

--
Pedro

