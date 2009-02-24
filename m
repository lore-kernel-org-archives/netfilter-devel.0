From: Patrick McHardy <kaber@trash.net>
Subject: Re: ROUTE patch
Date: Tue, 24 Feb 2009 16:33:18 +0100
Message-ID: <49A4133E.4070703@trash.net>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbZBXPdW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:33:22 -0500
In-Reply-To: <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-02-24 14:41, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> On Tuesday 2009-02-24 09:59, Abhishek Singh wrote:
>>>> What I would like to know is that if someone would like to add it to
>>>> the main iptables tree and the patchomatic repository. I am not sure
>>>> how to go about it. If someone is interested, please let me know. I
>>>> shall contribute the code and if would be happy to incorporate review
>>>> comments by other developers.
>>> [omg timeline!]
>>>
>>> Short answer, no. There is iproute2 and xt_TEE which replace it,
>>> and even patchomatic is gone.
>>>
>>> [/me takes a leap forward]
>> Perhaps we can finally get this merged. IIRC the only reason against
>> it is the IP layer duplication instead of simply using dst_output().
>>
> It cannot use dst_output because that would cause reentrancy into iptablse.
> Want a patch, though?

I would like to have a look at the current patch, yes. Don't
bother fixing anything though, I mainly want to have a look
at the routing part.
