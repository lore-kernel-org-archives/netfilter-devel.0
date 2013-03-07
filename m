From: David Miller <davem@redhat.com>
Subject: Re: [PATCH 0/3] netfilter fixes for your net tree
Date: Thu, 07 Mar 2013 15:23:41 -0500 (EST)
Message-ID: <20130307.152341.1494792387347754637.davem@redhat.com>
References: <1362654002-4405-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3CGUXo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:23:44 -0500
In-Reply-To: <1362654002-4405-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Thu,  7 Mar 2013 11:59:59 +0100

> The following patchset contains Netfilter fixes for your net tree,
> they are:
> 
> * Don't generate audit log message if audit is not enabled, from Gao Feng.
> 
> * Fix logging formatting for packets dropped by helpers, by Joe Perches.
> 
> * Fix a compilation warning in nfnetlink if CONFIG_PROVE_RCU is not set,
>   from Paul Bolle.
> 
> You can pull these changes from:
> 
> git://1984.lsi.us.es/nf master

Pulled, but keep in mind that if there are any bugs in these changes I
know exactly where you are. :-)

