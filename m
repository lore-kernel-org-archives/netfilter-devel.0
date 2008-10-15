From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables PATCH 1/2] Add iptables support for the TPROXY target
Date: Wed, 15 Oct 2008 11:52:00 +0200
Message-ID: <48F5BD40.8050305@trash.net>
References: <200810151010.15083@nessa> <alpine.LNX.1.10.0810150412020.10924@fbirervta.pbzchgretzou.qr> <200810151022.06435@nessa>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62850 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYJOJwE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:52:04 -0400
In-Reply-To: <200810151022.06435@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

KOVACS Krisztian wrote:
> On Wednesday 15 October 2008, Jan Engelhardt wrote:
>> A bit of forward planning would not have been bad; like using a
>> "union nf_inet_addr laddr" for a future IPv6 expansion, since those
>> pesky structs (xt_mymodule) tend be quite fixed and when they change,
>> they require a new revision.
> 
> You're right. However I don't consider adding a new revision much of a 
> problem when adding IPv6 support -- that is a major new feature anyway.
> 
> But I think we're still on time: feel free to submit a patch to DaveM 
> which changes the kernel side as well as a patch to the iptables modules.

It would be good to avoid adding more of these ugly revisions,
so yeah, feel free to send patches :)
