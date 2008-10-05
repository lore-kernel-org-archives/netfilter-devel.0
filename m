From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 01/16] [NETFILTER]: Re-add missing checkentry calls
Date: Sun, 5 Oct 2008 09:53:14 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810050948070.21891@fbirervta.pbzchgretzou.qr>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de> <48E8B831.7020609@trash.net> <alpine.LNX.1.10.0810050922510.21891@fbirervta.pbzchgretzou.qr> <48E8C1E8.5050309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36298 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbYJENxQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:53:16 -0400
In-Reply-To: <48E8C1E8.5050309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 09:32, Patrick McHardy wrote:
>
>> Hence these patches are generally designed for on-top-please.
>
> That makes sense of course, the question was more about whether
> it would make it easier for people doing bisections if I fold it.
> It applies cleanly on top of that change directly, so it wouldn't
> be a real problem.
>
Yes please fold if you can. (Given that I already got a "forced update"
on today's `git fetch`, I think it's ok ;-)
