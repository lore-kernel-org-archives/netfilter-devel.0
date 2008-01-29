From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [iptables PATCH trunk7285 7/7] fix gcc warnings
Date: Tue, 29 Jan 2008 15:51:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291546070.1185@fbirervta.pbzchgretzou.qr>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
 <20080127182503.15959.7989.stgit@woodpecker.roonstrasse.net>
 <479F2AF1.1070703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Max Kellermann <max@duempel.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYA2Ovp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:51:45 -0500
In-Reply-To: <479F2AF1.1070703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Jan 29 2008 14:32, Patrick McHardy wrote:

>> ---
>> 
>>  configure.ac                    |    5 +++--
>>  ...
>
> Applied, thanks. It caused a few new warnings though, could you fix
> those up as well?

The change to configure.ac was unnecessary. -W (sic: -Wextra) adds no 
new warnings except the ones I wanted to have ignored in the first 
place.

Well, I am going to fix it anyway. You just got it increased on my 
priority list.
