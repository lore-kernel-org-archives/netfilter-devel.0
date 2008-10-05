From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next-2.6.git tree updated
Date: Sun, 05 Oct 2008 16:00:37 +0200
Message-ID: <48E8C885.5020209@trash.net>
References: <48E8B028.1020701@trash.net> <48E8BAFE.2010907@trash.net> <alpine.LNX.1.10.0810050953300.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45410 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYJEOAn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:00:43 -0400
In-Reply-To: <alpine.LNX.1.10.0810050953300.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 09:02, Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> I've uploaded my current tree containing the patches applied during
>>> the netfilter workshop to kernel.org. It should show up on the public
>>> servers shortly.
>> One note - since I'm using stacked git and had to clean up a bit
>> of the history, the tree has to be recloned. Sorry about that,
>> I'll try to reduce this in the future and will add a warning in
>> case it happens.
> 
> Just declare the tree as "may change anytime without notice".
> linux-next is just the same, as is my git.medozas.de/linux. As long
> as people are aware, they write their history accordingly (i.e. not
> using merge points) and hence can use rebase.


Yes, but its more complicated and I would like to provide a more
stable base since at some point patches have to be diffed against
my tree. Dave's net trees are very good at this and the extra
effort really pays of for the consumers of them.

