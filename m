From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/16] [NETFILTER]: Re-add missing checkentry calls
Date: Mon, 06 Oct 2008 13:34:53 +0200
Message-ID: <48E9F7DD.4070302@trash.net>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de> <48E8B831.7020609@trash.net> <alpine.LNX.1.10.0810050922510.21891@fbirervta.pbzchgretzou.qr> <48E8C1E8.5050309@trash.net> <alpine.LNX.1.10.0810050948070.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37962 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYJFLfB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 07:35:01 -0400
In-Reply-To: <alpine.LNX.1.10.0810050948070.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 09:32, Patrick McHardy wrote:
>>> Hence these patches are generally designed for on-top-please.
>> That makes sense of course, the question was more about whether
>> it would make it easier for people doing bisections if I fold it.
>> It applies cleanly on top of that change directly, so it wouldn't
>> be a real problem.
>>
> Yes please fold if you can. (Given that I already got a "forced update"
> on today's `git fetch`, I think it's ok ;-)
> 

Done, thanks.
