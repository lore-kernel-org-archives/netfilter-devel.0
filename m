From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] [RFC] nfnetlink_acct: Traffic-based and periodic
 notifications
Date: Thu, 5 Sep 2013 10:27:52 +0200
Message-ID: <20130905082752.GA3975@localhost>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
 <20130904123920.GB4900@localhost>
 <522839BC.6000909@oss.bmw-carit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: valentina.giusti@bmw-carit.de, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Valentina Giusti <valentina.giusti@oss.bmw-carit.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35385 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab3IEI15 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:27:57 -0400
Content-Disposition: inline
In-Reply-To: <522839BC.6000909@oss.bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 05, 2013 at 09:58:52AM +0200, Valentina Giusti wrote:
[...]
> As I mentioned, there are
> 
> "applications (e.g. connman) which currently need to keep polling
> accounting objects via nfnl_acct_get() in order to get updated
> statistics. This is far from ideal in scenarios with large amounts
> of accounting objects and diverse, unpredictable network traffic."

You get around 100 accounting objects with one single recv syscall on
x86_64 when polling from userspace. If you're noticing performance
issues with this approach, please report them more precisely.

Regards.
