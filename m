From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnl netfilter log
Date: Sun, 09 Dec 2007 17:08:22 +0100
Message-ID: <475C12F6.5000801@trash.net>
References: <475A2987.8030505@trash.net> <475ADF79.1030204@netfilter.org> <475AE163.9040005@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>, Thomas Graf <tgraf@suug.ch>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56210 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXLIQIx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:08:53 -0500
In-Reply-To: <475AE163.9040005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hm, wait. Did libnl adopt an API similar to libnetfilter_log? Uh bad :)
> Then, instead of changing the API that is something that could break any
> existing application, I think that you can introduce the new API that
> you propose and put the old one with the __attribute__((deprecated)) thing.

Its quite new, I guess there are no applications yet.

> BTW, is libnl website broken? Any CVS or something I can get a working
> copy to have a look at current netfilter support?

Its hosted on http://git.kernel.org

