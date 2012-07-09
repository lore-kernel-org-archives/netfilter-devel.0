From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH v2 5/6] netfilter: tarpit: Add IPv6 support
Date: Mon, 09 Jul 2012 09:02:05 -0500
Message-ID: <4FFAE45D.6070603@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com> <1341771085-5771-6-git-send-email-johunt@akamai.com> <alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:47174 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab2GIOCI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:02:08 -0400
In-Reply-To: <alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/08/2012 02:36 PM, Jan Engelhardt wrote:
> On Sunday 2012-07-08 20:11, Josh Hunt wrote:
>
>> This adds IPv6 support for the tarpit target. It performs the same
>> functionality as the v4 version, but with IPv6 connections.
>
> I have applied the rest so far; see the "tarpit6" branch of the git
> repository,
>
> I have applied the rest so far, with minor modifications regarding
> style. See the "tarpit6" branch of the git repository.
>
> This patch 5 does not compile for Linuxes >= v3.3 due to new arguments
> to ipv6_skip_exthdr and the removal of ipv6_addr_copy. Please send an
> additional patch on top to make it work with Linux 3.5(-rc). There will
> be no need to add #ifdefs for 3.3ish, because compat_xtables* already
> takes care of that mostly.
>
>
Jan

I just sent a patch doing what you've requested above against the 
tarpit6 branch, and it builds fine now with Linus' latest git. However, 
I did not see the compat layer stuff to keep me from neededing #ifdefs. 
Perhaps I wasn't looking in the right spot.

Also, please let me know if there are any issues with the libxt patch. I 
did not see it in the tarpit6 branch.

Josh

