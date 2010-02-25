From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: macvlan device blocks traffic for 30 secs
Date: Thu, 25 Feb 2010 18:33:18 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251832340.13151@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002251743590.30827@obet.zrqbmnf.qr> <4B86AB36.6090402@trash.net> <alpine.LSU.2.01.1002251817040.13151@obet.zrqbmnf.qr> <4B86B132.9090906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34270 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab0BYRdU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:33:20 -0500
In-Reply-To: <4B86B132.9090906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-25 18:19, Patrick McHardy wrote:
>>>> Can you reproduce this?
>>> No, this works fine here. It might be related to filter reprogramming
>>> of the NIC. Which driver are you using?
>> 
>> tap0 on one the host, e1000 inside the virtualbox.
>
>I have no idea about virtualbox. I guess it might be related to
>bridging.

There is no vm bridging at all, it's plain routing between tap and eth 
(aka "Host Only Networking" in VMware slingo).
