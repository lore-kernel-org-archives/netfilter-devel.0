From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 01/16] [NETFILTER]: Re-add missing checkentry calls
Date: Sun, 5 Oct 2008 09:25:09 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810050922510.21891@fbirervta.pbzchgretzou.qr>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de> <48E8B831.7020609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58509 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYJENZL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:25:11 -0400
In-Reply-To: <48E8B831.7020609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 08:50, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> A previous commit ("Move Ebtables to use Xtables") unfortunately
>> removed match and target checks in Ebtables. Add it back. Some checks
>> go into xtables.c as part of consolidation work.
>
> Should I fold this one into the patch that removed them?
>
I am not always sure of your procedure. When you say "applied, thanks", 
I have to assume it is already in a non-resettable git tree where 
folding is impossible. Hence these patches are generally designed for 
on-top-please.
