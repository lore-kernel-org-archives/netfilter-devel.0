From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: The glorious NFCT "none" helper
Date: Mon, 23 May 2011 18:13:07 +0200
Message-ID: <4DDA8793.7010203@netfilter.org>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de> <4DDA6F53.9060809@trash.net> <4DDA8184.3060407@netfilter.org> <alpine.LNX.2.01.1105231755550.18360@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46459 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab1EWQNM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 12:13:12 -0400
In-Reply-To: <alpine.LNX.2.01.1105231755550.18360@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23/05/11 17:59, Jan Engelhardt wrote:
> On Monday 2011-05-23 17:47, Pablo Neira Ayuso wrote:
> 
>> On 23/05/11 16:29, Patrick McHardy wrote:
>>> On 19.05.2011 00:21, Jan Engelhardt wrote:
>>>> Hej,
>>>>
>>>>
>>>> While working with a customer setup, I came up with this funny idea
>>>> of plugging a no-op NFCT helper in to workaround some nfct_ftp
>>>> problem. Besides that, it may also be used to simply skip helping and
>>>> save cycles. See the patch's message for details - I'd love to hear
>>>> something about it.
>>>>
>>>> (NB: nf_nat_ftp was loaded, but not used when connecting between netA
>>>> and netB.)
>>>
>>> Wouldn't a flag to the CT target to skip the helper lookup work as well?
>>
>> Indeed.
> 
> Yes, but how would xt_CT.ko convey to NFCT then that no helper is 
> supposed to be used? Calling nf_ct_helper_ext_add, but then leave help 
> at NULL?

You can attach a template conntrack in the raw table with the CT target.
That template should have some status flag set to skip helper
allocation/assignation.

I sent a patch to Patrick to fix some problem with the current userspace
expectation approach, the idea would be similar.
