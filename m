From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: The glorious NFCT "none" helper
Date: Mon, 23 May 2011 17:59:49 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105231755550.18360@frira.zrqbmnf.qr>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de> <4DDA6F53.9060809@trash.net> <4DDA8184.3060407@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48616 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1EWP7v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 11:59:51 -0400
In-Reply-To: <4DDA8184.3060407@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-05-23 17:47, Pablo Neira Ayuso wrote:

>On 23/05/11 16:29, Patrick McHardy wrote:
>> On 19.05.2011 00:21, Jan Engelhardt wrote:
>>> Hej,
>>>
>>>
>>> While working with a customer setup, I came up with this funny idea
>>> of plugging a no-op NFCT helper in to workaround some nfct_ftp
>>> problem. Besides that, it may also be used to simply skip helping and
>>> save cycles. See the patch's message for details - I'd love to hear
>>> something about it.
>>>
>>> (NB: nf_nat_ftp was loaded, but not used when connecting between netA
>>> and netB.)
>> 
>> Wouldn't a flag to the CT target to skip the helper lookup work as well?
>
>Indeed.

Yes, but how would xt_CT.ko convey to NFCT then that no helper is 
supposed to be used? Calling nf_ct_helper_ext_add, but then leave help 
at NULL?

