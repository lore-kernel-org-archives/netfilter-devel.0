From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: The glorious NFCT "none" helper
Date: Mon, 23 May 2011 17:47:16 +0200
Message-ID: <4DDA8184.3060407@netfilter.org>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de> <4DDA6F53.9060809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1EWPr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 11:47:28 -0400
In-Reply-To: <4DDA6F53.9060809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23/05/11 16:29, Patrick McHardy wrote:
> On 19.05.2011 00:21, Jan Engelhardt wrote:
>> Hej,
>>
>>
>> While working with a customer setup, I came up with this funny idea
>> of plugging a no-op NFCT helper in to workaround some nfct_ftp
>> problem. Besides that, it may also be used to simply skip helping and
>> save cycles. See the patch's message for details - I'd love to hear
>> something about it.
>>
>> (NB: nf_nat_ftp was loaded, but not used when connecting between netA
>> and netB.)
> 
> Wouldn't a flag to the CT target to skip the helper lookup work as well?

Indeed.
