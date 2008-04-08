From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] [NETFILTER]: xt_length match, revision 1
Date: Tue, 08 Apr 2008 17:28:15 +0200
Message-ID: <47FB8F0F.3010702@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <9e46f22a9f7950b9f924d7918be23da9127e7eef.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42383 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYDHP20 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:28:26 -0400
In-Reply-To: <9e46f22a9f7950b9f924d7918be23da9127e7eef.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Introduce xt_length match revision 1. It adds support for layer-4,
> layer-5 and layer-7 length matching. It is much easier than writing
> up the according xt_u32 magic.
> 
> This can be used for packet scheduling; specific example are online
> games where all data is transferred over the same port, but the
> regular gameplay has a characteristically lower packet size than bulk
> downloads of game maps. (Tested with Unreal Tournament 99.)


I'll let this sit on the list for a few more days in case
someone else has comments. I'm personally not a huge fan
of bloating this length module like this. Perhaps something
more minimalistic would also do the trick?


