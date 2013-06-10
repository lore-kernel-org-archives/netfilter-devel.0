From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 3/5] netfilter: xt_TCPMSS: Fix violation of RFC879 in
 absence of MSS option
Date: Mon, 10 Jun 2013 04:27:39 -0400
Message-ID: <20130610082739.GA14277@gmail.com>
References: <1370880461-4265-1-git-send-email-pablo@netfilter.org>
 <1370880461-4265-4-git-send-email-pablo@netfilter.org>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7282@saturn3.aculab.com>
 <20130610071954.GA13500@gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7285@saturn3.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47744 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3FKP51 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:57:27 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so4467841pad.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2013 08:57:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7285@saturn3.aculab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 11, 2013 at 04:00:06PM +0100, David Laight wrote:
> To quote that bug:
> 
> I stumbled upon this problem in debian bug #541658[1] ("[iceweasel] cannot open 
> research.microsoft.com" - only worth reading for entertainment purposes) and,
> after that bug was closed, analysed it in my blog[2] until a friend of mine
> found out why the page loads when clamping mss to pmtu is disabled or
> restricted to a range (like with "iptables -A FORWARD -p tcp --tcp-flags
> SYN,RST SYN -m tcpmss --mss 1400:1536 -j TCPMSS --clamp-mss-to-pmtu") but
> doesn't load with "simple" clamping. His really great and detailed analysation
> of the problem may be seen at [3].
> 
> If I read/understand that correctly, clamping to 1400 worked - there was
> no need to clamp all the way down to 536.

You are not understanding the issue correctly.  The reason the command worked with
"-m tcpmss --mss 1400:1536" is because that implies an MSS option was provided.
The issue occurs only when NO MSS option is sent.  In these cases, we cannot
ASSUME that it is ok to use some arbitrarily high value (1400 as you propose).
The RFC is clear on this point.

Phil
