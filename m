From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ROUTE patch
Date: Tue, 24 Feb 2009 16:30:42 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51559 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZBXPap (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:30:45 -0500
In-Reply-To: <49A3F922.4050508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-24 14:41, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Tuesday 2009-02-24 09:59, Abhishek Singh wrote:
>>> What I would like to know is that if someone would like to add it to
>>> the main iptables tree and the patchomatic repository. I am not sure
>>> how to go about it. If someone is interested, please let me know. I
>>> shall contribute the code and if would be happy to incorporate review
>>> comments by other developers.
>>
>> [omg timeline!]
>>
>> Short answer, no. There is iproute2 and xt_TEE which replace it,
>> and even patchomatic is gone.
>>
>> [/me takes a leap forward]
>
> Perhaps we can finally get this merged. IIRC the only reason against
> it is the IP layer duplication instead of simply using dst_output().
>
It cannot use dst_output because that would cause reentrancy into iptablse.
Want a patch, though?
