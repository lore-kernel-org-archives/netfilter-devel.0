From: Patrick McHardy <kaber@trash.net>
Subject: Re: Looking for mentor: NetFlow support for NetFilter
Date: Sun, 01 Jun 2008 23:16:35 +0200
Message-ID: <484311B3.70102@trash.net>
References: <483E26A1.2010401@ez.pereslavl.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Mikhailov <karma@ez.pereslavl.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYFAVQk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:16:40 -0400
In-Reply-To: <483E26A1.2010401@ez.pereslavl.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Mikhailov wrote:
> Greetings, NetFilter developers.
> 
> I was developing new efficient way of network accounting in Linux. It's 
> based on generating
> NetFlow packets in-kernel using conntrack system. I've got some 
> progress, made some
> decisions, some of them are very questionable. So I'm looking for a 
> mentor from NetFilter
> side to discuss my ideas and my code with him. It's too early to discuss 
> it publically.

Have you looked at ulogd2? It can generate netflow data from
the conntrack accounting information.

