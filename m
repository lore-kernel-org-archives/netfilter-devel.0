From: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Subject: Re: [PATCH 6/7] netfilter: nf_conntrack: fix ct refcount leak in l4proto->error()
Date: Mon, 06 Jun 2011 06:10:39 +0400
Message-ID: <402391307326240@web153.yandex.ru>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org> <1307319100-21827-7-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward13.mail.yandex.net ([95.108.130.120]:58513 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1FFCRM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 22:17:12 -0400
In-Reply-To: <1307319100-21827-7-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

06.06.2011, 04:11, pablo@netfilter.org:

> With this patch, we can also fix wrong return values (-NF_ACCEPT)
> for special cases in ICMP[v6] that should not bump the invalid/error
> statistic counters.

Are you sure? Please, look here:

http://www.spinics.net/lists/netfilter-devel/msg15520.html

Thank you!

-- 
wbr, Oleg.
