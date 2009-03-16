From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: crash bug due to a missing initialization
Date: Mon, 16 Mar 2009 09:47:55 +0100
Message-ID: <49BE123B.4070403@netfilter.org>
References: <20090313111818.GA5359@zebra.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41112 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753135AbZCPIsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:48:05 -0400
In-Reply-To: <20090313111818.GA5359@zebra.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BORBELY Zoltan wrote:
> Hi,
> 
> In the ctnetlink_create_expect() function (in file nf_conntrack_netlink.c),
> you forgot to initialize exp->class, which causes a crash in the
> nf_ct_expect_related() function. I've just put an
> 
>     exp->class = 0;
> 
> line before the exp->expectfn = NULL line, and it has solved the problem.

Good catch.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
