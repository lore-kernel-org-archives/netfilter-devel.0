From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC] xt_layer7
Date: Sun, 05 Oct 2008 15:50:47 +0200
Message-ID: <48E8C637.5060700@trash.net>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com> <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James King <t.james.king@gmail.com>,
	Matthew Strait <quadong@users.sourceforge.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45224 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbYJENuy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:50:54 -0400
In-Reply-To: <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2008-10-04 03:22, James King wrote:
> 
>> I've re-written xt_layer7 (l7-filter) so that it not longer requires
>> patching of the nf_conn structure for data storage, using ct_extend
>> instead, with the goal that it can eventually be used against a
>> vanilla kernel with an unpatched iptables.
> 
> I had the same idea too a while back but put off on it - busy with
> other iptables things :)
> 
> Right now, you still cannot use it with a vanilla kernel because
> patches like #3 you attached enlarges the allocated region (remember,
> NF_CT_EXT_NUM just increased by one!), which is going to be a big
> impact {for users not using all the extensions} {if every imaginable
> extensions adds itself a NF_CT_EXT_ number}.
> 
> Can someone think of a way to nicely fix this up? Like, a linked
> list instead of the ct_extend[] array perhaps? Yes yes, that's not O(1),
> but how many extensions at a time are you using anyway!

That would have a pretty big storage and runtime impact, I
don't think its a good idea.

I think I could agree to add something like a NF_CT_EXT_LIST
extensions that wouldn't be used by mainline, but you could
use it for xtables-addons. There's some padding in nf_ct_ext
so it would (currently) not have any negative impact on mainline.
I haven't spent much though on this so it might not work though.
