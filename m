From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Sat, 7 Mar 2009 01:26:09 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903070125440.19019@fbirervta.pbzchgretzou.qr>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr> <49A4133E.4070703@trash.net>
 <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr> <49A51B26.3050906@trash.net> <alpine.LSU.2.00.0902251120250.20946@fbirervta.pbzchgretzou.qr> <49A51D95.9080009@trash.net> <alpine.LSU.2.00.0902251543370.4191@fbirervta.pbzchgretzou.qr>
 <49A66902.2060505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41852 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZCGA0N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:26:13 -0500
In-Reply-To: <49A66902.2060505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-26 11:03, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Wednesday 2009-02-25 11:29, Patrick McHardy wrote:
>>>>> An index is probably useful when you want to mirror packets
>>>>> somewhere outside of regular routing.
>>>>
>>>> ifindex?
>>> Yes.

Ok so I added iif, nfmark and flowlabel now.
