From: Patrick McHardy <kaber@trash.net>
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
Date: Mon, 13 Oct 2008 15:44:31 +0200
Message-ID: <48F350BF.2090301@trash.net>
References: <9b2db90b0810101349y7e357ef7g9c53f2ecf19fe3eb@mail.gmail.com> <9b2db90b0810101350o52d79ecka27409bfd3eaf1f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Nir Tzachar <nir.tzachar@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37203 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYJMNoe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:44:34 -0400
In-Reply-To: <9b2db90b0810101350o52d79ecka27409bfd3eaf1f8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nir Tzachar wrote:
> On Fri, Oct 10, 2008 at 10:49 PM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
>>>>> And I always get  the following warning twice:
>>>>>
>>>>> [ 6658.338116] ------------[ cut here ]------------
>>>>> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
>>>>> nf_nat_fn+0x33/0x155()

>>> Found it - we lost an ifdef during the transition to nf_conntrack
>>> guarding an exception from defragmentation on loopback input.
>>> This patch should fix the warning.
>>
> 
> Yes, the patch below fixes the problem.

Thanks for testing, I've queued the patch for 2.6.28 and -stable.
