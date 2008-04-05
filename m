From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: DCCP conntrack/NAT
Date: Sat, 05 Apr 2008 12:12:08 +0200
Message-ID: <47F75078.3070205@netfilter.org>
References: <47F64C0D.5080700@trash.net> <alpine.LNX.1.10.0804042152090.26881@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55774 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751376AbYDEKMO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 06:12:14 -0400
In-Reply-To: <alpine.LNX.1.10.0804042152090.26881@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Friday 2008-04-04 17:41, Patrick McHardy wrote:
>> These two patches contain my old conntrack/NAT helper for DCCP,
>> updated to net-2.6.26.git and the missing parts (almost entirely)
>> added.
>>
>> They both depend on some other netfilter patches, I've attached
>> them only hoping for some review :) A git tree which contains
>> the full set of patches is (once upload finishes) located at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.26.git
> 
> Speaking of git... I noticed people.netfilter.org has a git-daemon,
> so that would be fine for iptables, no?

No, that's for a different purpose. We are setting up another git
repository in Vishnu that will keep soon iptables.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
