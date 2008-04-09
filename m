From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] [NETFILTER]: xt_length match, revision 1
Date: Wed, 09 Apr 2008 18:25:18 +0200
Message-ID: <47FCEDEE.2020309@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <9e46f22a9f7950b9f924d7918be23da9127e7eef.1207664141.git.jengelh@computergmbh.de> <47FB8F0F.3010702@trash.net> <alpine.LNX.1.10.0804091818350.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52405 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbYDIQZV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:25:21 -0400
In-Reply-To: <alpine.LNX.1.10.0804091818350.3866@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-08 17:28, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Introduce xt_length match revision 1. It adds support for layer-4,
>>> layer-5 and layer-7 length matching. It is much easier than writing
>>> up the according xt_u32 magic.
>>>
>>> This can be used for packet scheduling; specific example are online
>>> games where all data is transferred over the same port, but the
>>> regular gameplay has a characteristically lower packet size than bulk
>>> downloads of game maps. (Tested with Unreal Tournament 99.)
>> I'll let this sit on the list for a few more days in case
>> someone else has comments. I'm personally not a huge fan
>> of bloating this length module like this. Perhaps something
>> more minimalistic would also do the trick?
> 
> Have something special in mind?
> 

In my opinion all the kernel should needs to be able to do
is to deal with variable length headers, everything else can
be calculated by userspace(/the user).

So for example if you can match on the IP payload length,
you *know* the UDP data length is that value - 8.

Whats that SCTP thing about?
