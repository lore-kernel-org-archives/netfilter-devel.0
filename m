From: Pierre Chifflier <chifflier@edenwall.com>
Subject: Re: [PATCH 3/3] bridge: add new target NFQUEUE for ebtables
Date: Fri, 04 Feb 2011 14:40:02 +0100
Message-ID: <4D4C01B2.2030605@edenwall.com>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-4-git-send-email-chifflier@edenwall.com> <4D4BFE3C.3060407@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:35765 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120Ab1BDNkE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:40:04 -0500
In-Reply-To: <4D4BFE3C.3060407@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/04/2011 02:25 PM, Patrick McHardy wrote:
> On 03.02.2011 15:32, Pierre Chifflier wrote:
>> This adds support for sending bridge packets to userspace using
>> the NFQUEUE target with ebtables.
> 
> I don't think we need a new target for this (and the EBT_QUEUE
> definition), just using xt_NFQUEUE should work fine.

I thought ebtables did not support sending packet to xtables ? (that's
on the TODO list for ebtables).

