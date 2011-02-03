From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: WIP/RFC: add new module ebt_NFQUEUE for ebtables
Date: Thu, 03 Feb 2011 21:19:41 +0100
Message-ID: <4D4B0DDD.5090703@pandora.be>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-1-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:40740 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1BCUYo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:24:44 -0500
In-Reply-To: <1296743540-8148-1-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 3/02/2011 15:32, Pierre Chifflier schreef:
> Hi,
>
> Here is the code as requested for the module I'm trying to add.
> Basically, the code is split in two parts:
> - patch 1 and 2 prepare the ebtables and nfqueue existing code to allow
>    sending packets from ebtables. Since these packets are labelled PF_BRIDGE
>    they have no afinfo structure, so we just ignore (instead of exiting)
> - patch 3 adds the new module, which just always returns EBT_QUEUE
>
> This is of course not meant for inclusion, but comments would be welcome.
>
I'm not too familiar with nf_queue, but I don't see you register a queue 
handler for NFPROTO_BRIDGE.
Why does __nf_queue even queue the packet to userspace if you didn't 
register a queue handler for pf=NFPROTO_BRIDGE?
For debugging, you could experiment with iptables' queue target for 
bridged IP traffic (iptables can be enabled to see bridged traffic)... 
Since the queueing is basically done in the same bridge context for this 
traffic, it should help you.

Bart

-- 
Bart De Schuymer
www.artinalgorithms.be


