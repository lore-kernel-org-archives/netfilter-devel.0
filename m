From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next-2.6.git tree updated
Date: Sun, 5 Oct 2008 09:55:14 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810050953300.21891@fbirervta.pbzchgretzou.qr>
References: <48E8B028.1020701@trash.net> <48E8BAFE.2010907@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54966 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYJENzP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:55:15 -0400
In-Reply-To: <48E8BAFE.2010907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 09:02, Patrick McHardy wrote:
> Patrick McHardy wrote:
>> I've uploaded my current tree containing the patches applied during
>> the netfilter workshop to kernel.org. It should show up on the public
>> servers shortly.
>
> One note - since I'm using stacked git and had to clean up a bit
> of the history, the tree has to be recloned. Sorry about that,
> I'll try to reduce this in the future and will add a warning in
> case it happens.

Just declare the tree as "may change anytime without notice".
linux-next is just the same, as is my git.medozas.de/linux. As long
as people are aware, they write their history accordingly (i.e. not
using merge points) and hence can use rebase.
