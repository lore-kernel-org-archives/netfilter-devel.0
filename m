From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Wed, 24 Mar 2010 16:22:02 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003241616120.20299@obet.zrqbmnf.qr>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de> <4BAA2969.8010106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38793 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab0CXPWF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:22:05 -0400
In-Reply-To: <4BAA2969.8010106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-24 16:02, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> xt_conntrack has been provided since v2.5.32.
>>   
>
>I'm fine with the removal of old revisions, but how are you planning on
>informing users about removal of this module? Most people don't read
>feature-removal-schedule, and distributions are unable to help with
>user written scripts.

I would suggest to do the same as we did with disallowing DROP in the 
nat table:

 - a message printed by iptables whenever -m state is used

 - a kernel message whenever whenever a rule with xt_state is created

We did not actually do the kernel side with nat-prohibit-DROP, but I
regard it as very useful, as the community was very much able to help
itself if only they got the word - and it turned out that dmesg is
_the_ place people look in especially when they don't supervise
iptables output directly, as with, for example, boot splash where
messages are hidden, or server/router devices that one tends to
forget about.
