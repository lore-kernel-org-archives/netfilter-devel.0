From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 8/8] [NETFILTER]: xt_length match, revision 1
Date: Wed, 9 Apr 2008 18:18:47 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091818350.3866@fbirervta.pbzchgretzou.qr>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <9e46f22a9f7950b9f924d7918be23da9127e7eef.1207664141.git.jengelh@computergmbh.de> <47FB8F0F.3010702@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59711 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYDIQSs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:18:48 -0400
In-Reply-To: <47FB8F0F.3010702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-04-08 17:28, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Introduce xt_length match revision 1. It adds support for layer-4,
>> layer-5 and layer-7 length matching. It is much easier than writing
>> up the according xt_u32 magic.
>> 
>> This can be used for packet scheduling; specific example are online
>> games where all data is transferred over the same port, but the
>> regular gameplay has a characteristically lower packet size than bulk
>> downloads of game maps. (Tested with Unreal Tournament 99.)
>
> I'll let this sit on the list for a few more days in case
> someone else has comments. I'm personally not a huge fan
> of bloating this length module like this. Perhaps something
> more minimalistic would also do the trick?

Have something special in mind?
