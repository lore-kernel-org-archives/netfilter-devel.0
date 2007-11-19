From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv4 0/2] Find address type on the packet's interface
Date: Mon, 19 Nov 2007 18:12:12 +0100
Message-ID: <4741C3EC.3050500@trash.net>
References: <11954877483732-git-send-email-panther@balabit.hu> <4741B47A.40106@trash.net> <Pine.LNX.4.64.0711191756550.32378@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38504 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbXKSRMf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:12:35 -0500
In-Reply-To: <Pine.LNX.4.64.0711191756550.32378@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 19 2007 17:06, Patrick McHardy wrote:
>> I just read up on your and Jan's discussion, but you were too fast
>> for me :) I'm not sure whether this is really a good candidate
>> for x_tables. IPv4 and IPv6 addrtype have different meanings, the
>> IPv4 addrtype is based on routing, IPv6 solely on the address.
>> Especially things like "--addrtype local" won't work, which is
>> IMO the most useful feature. And since you don't actually add IPv6
>> support, I don't see any advantage in moving to x_tables. So I
>> think for now I'd prefer a change to the ipt_addrtype match.
> 
> IMHO it does not make any difference whether it is xt_*.c or ipt_*.c,
> the cost is quite the same.
> I am all for xt_*.c, because that's the "new shiny" thing.

x_tables is meant for unified matches and targets, as long as theres
nothing to unify, there's no point in moving it over. So far I think
we only have a single xtables match that doesn't support both IPv4
and IPv6 (xt_conntrack), and I'd like to keep it that way.

