From: Patrick McHardy <kaber@trash.net>
Subject: Re: The glorious NFCT "none" helper
Date: Tue, 24 May 2011 09:06:41 +0200
Message-ID: <4DDB5901.2090607@trash.net>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de> <4DDA6F53.9060809@trash.net> <4DDA8184.3060407@netfilter.org> <alpine.LNX.2.01.1105231755550.18360@frira.zrqbmnf.qr> <4DDA8793.7010203@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48788 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1EXHHN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 03:07:13 -0400
In-Reply-To: <4DDA8793.7010203@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.05.2011 18:13, Pablo Neira Ayuso wrote:
> On 23/05/11 17:59, Jan Engelhardt wrote:
>> On Monday 2011-05-23 17:47, Pablo Neira Ayuso wrote:
>>
>>> On 23/05/11 16:29, Patrick McHardy wrote:
>>>> On 19.05.2011 00:21, Jan Engelhardt wrote:
>>>>> Hej,
>>>>>
>>>>>
>>>>> While working with a customer setup, I came up with this funny idea
>>>>> of plugging a no-op NFCT helper in to workaround some nfct_ftp
>>>>> problem. Besides that, it may also be used to simply skip helping and
>>>>> save cycles. See the patch's message for details - I'd love to hear
>>>>> something about it.
>>>>>
>>>>> (NB: nf_nat_ftp was loaded, but not used when connecting between netA
>>>>> and netB.)
>>>>
>>>> Wouldn't a flag to the CT target to skip the helper lookup work as well?
>>>
>>> Indeed.
>>
>> Yes, but how would xt_CT.ko convey to NFCT then that no helper is 
>> supposed to be used? Calling nf_ct_helper_ext_add, but then leave help 
>> at NULL?
> 
> You can attach a template conntrack in the raw table with the CT target.
> That template should have some status flag set to skip helper
> allocation/assignation.

Problem might be the second lookup done after NAT. We don't have the
template available at that time.

I don't like the dummy helper idea very much though, what I would
prefer is an option to use only explicit helper assignment. That
would be a more flexible option, additionally allowing to track
protocols on any port without specifying each of them when loading
the helper.
