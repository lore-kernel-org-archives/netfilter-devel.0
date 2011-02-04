From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] bridge: add new target NFQUEUE for ebtables
Date: Fri, 04 Feb 2011 14:41:30 +0100
Message-ID: <4D4C020A.9000909@trash.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-4-git-send-email-chifflier@edenwall.com> <4D4BFE3C.3060407@trash.net> <4D4C01B2.2030605@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46880 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1BDNlq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:41:46 -0500
In-Reply-To: <4D4C01B2.2030605@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02.2011 14:40, Pierre Chifflier wrote:
> On 02/04/2011 02:25 PM, Patrick McHardy wrote:
>> On 03.02.2011 15:32, Pierre Chifflier wrote:
>>> This adds support for sending bridge packets to userspace using
>>> the NFQUEUE target with ebtables.
>>
>> I don't think we need a new target for this (and the EBT_QUEUE
>> definition), just using xt_NFQUEUE should work fine.
> 
> I thought ebtables did not support sending packet to xtables ? (that's
> on the TODO list for ebtables).

It can use xtables targets and matches if I'm not completely
mistaken.

