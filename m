From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Tue, 15 Jan 2008 07:48:29 +0100
Message-ID: <478C573D.2060401@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYAOGsi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:48:38 -0500
In-Reply-To: <477E487D.8000901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 7e6ab7f2e7eb220d2ee5ce7f744a22deb10a5144
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 17:55:31 2008 +0100
>>
>>     [NETFILTER]: xt_conntrack match, revision 1
>>         Introduces the xt_conntrack match revision 1. It uses fixed 
>> types, the
>>     new nf_inet_addr and comes with IPv6 support, thereby completely
>>     superseding xt_state.
> 
> Applied.


This reminded me - while we're introducing new revisions, there
are two things that have always been missing from xt_conntrack
and I know of multiple patches adding this. One is port matching
for both directions, the other is matching on the direction
itself. Would you be interested in adding this? Otherwise I'm
going to take care of it myself.

