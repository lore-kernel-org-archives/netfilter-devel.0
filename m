From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/3] netfilter: af_info: add 'strict' parameter to
 limit lookup to .oif
Date: Mon, 21 Mar 2011 16:58:29 -0700 (PDT)
Message-ID: <20110321.165829.28821319.davem@davemloft.net>
References: <1300746341-18011-2-git-send-email-fw@strlen.de>
	<1300747149.2837.22.camel@edumazet-laptop>
	<1300747379.2837.23.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: eric.dumazet@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53099
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250Ab1CUX5u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:57:50 -0400
In-Reply-To: <1300747379.2837.23.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 21 Mar 2011 23:42:59 +0100

> Ah sorry, I missed the "static const". Maybe I should just sleep now ;)

Well, I would really prefer if ip6_route_output() and friends mark
their 'sk' argument as 'const'.

Otherwise someone is going to read this code and be really concerned
that "sk" really might be modified in some way by this code path,
thus making parallel access to this static const 'sk' illegal.
