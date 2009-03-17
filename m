From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 14:54:59 +0100
Message-ID: <49BFABB3.9020903@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <alpine.LNX.1.10.0903171409550.17354@bizon.gios.gov.pl> <alpine.LSU.2.00.0903171425520.30677@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0903171450330.14581@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Holger Eitzenberger <holger@eitzenberger.org>,
	pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47980 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZCQNzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:55:03 -0400
In-Reply-To: <alpine.LNX.1.10.0903171450330.14581@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>> The implication is that xt_connbytes will not do the right thing
>> anymore as soon as user accounting is turned off, either by flipping
>> the sysctl value or deactivating the kconfig option. That is not
>> good.
> 
> The sysctl is not going to be removed and you can still set the initial 
> value with the proper kernel/module option. I fail to see the problem here.

Its mainly a usability thing. Its not really obvious that the
match will be entirely without effect if you don't set some sysctl.
And since we can assume that anyone using the connbytes match
intends for it to have some effect, we might as well enable it
automatically.
