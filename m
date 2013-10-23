From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] netfilter: x_tables: fix ordering of jumpstack
 allocation and table update
Date: Wed, 23 Oct 2013 10:04:56 -0700
Message-ID: <1382547896.7572.29.camel@edumazet-glaptop.roam.corp.google.com>
References: <1382519724-3953-1-git-send-email-pablo@netfilter.org>
	 <1382519724-3953-4-git-send-email-pablo@netfilter.org>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73A2@saturn3.aculab.com>
	 <20131023163706.GA5117@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Laight <David.Laight@ACULAB.COM>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:41001 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3JWRFB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:05:01 -0400
In-Reply-To: <20131023163706.GA5117@mudshark.cambridge.arm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2013-10-23 at 17:37 +0100, Will Deacon wrote:

> What I'm *not* 100% sure about is the table freeing path. There is a mutex
> there for removing the table from a list, but I'm not sure how we ensure
> that there are no parallel readers at that point.

Sequence is :

xt_replace_table();
get_counters();
xt_free_table_info();

get_counters() is the way we ensure no cpu is using old copy of the
table before freeing.




