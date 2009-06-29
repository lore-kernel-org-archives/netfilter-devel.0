From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack untracked match is broken (kernel patch)
Date: Mon, 29 Jun 2009 14:34:10 +0200
Message-ID: <4A48B4C2.7080106@trash.net>
References: <4A3F2547.30301@snapgear.com> <alpine.LSU.2.00.0906251841140.23831@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Philip Craig <philipc@snapgear.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35948 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZF2MeN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:34:13 -0400
In-Reply-To: <alpine.LSU.2.00.0906251841140.23831@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-06-22 08:31, Philip Craig wrote:
>> The problem is that state_mask in 'struct xt_conntrack_mtinfo1' is
>> only 8 bit, but XT_CONNTRACK_STATE_UNTRACKED == 256.
>> Unfortunately, gcc doesn't warn about this for '|=', only for '='.
> 
> I smell a gcc-missing-feature there.
> 
>> Looks like we need a conntrack match v2 to fix this?

Sigh.

> Here is the kernel patch, please apply. Userspace as a reply.
> 
> -----8<-----
> parent deb9f8e170eff8fd0476536bac3bf9bdc222d4ed (v2.6.30-5372-gdeb9f8e)
> commit 366d5a252fd0de33d7b3ef669551a8771748c9e3
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Jun 25 18:35:39 2009 +0200
> 
> netfilter: xtables: conntrack revision 2
> 
> As reported by Philip, the UNTRACKED state bit does not fit within
> the 8-bit state_mask member. Enlarge state_mask and give status_mask
> a few more bits too.

Applied.
