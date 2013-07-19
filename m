From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 4/4] rule: change type of function to use
 const
Date: Fri, 19 Jul 2013 14:32:49 +0200
Message-ID: <20130719123249.GD30571@localhost>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
 <1373124796-6810-1-git-send-email-eric@regit.org>
 <1373124796-6810-4-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45988 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3GSMcx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:32:53 -0400
Content-Disposition: inline
In-Reply-To: <1373124796-6810-4-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 06, 2013 at 05:33:16PM +0200, Eric Leblond wrote:
> The function nft_rule_attr_is_set() is doing no modification so it
> is possible to type it to const.

I have mangled this patch to adapt all other nft_*_attr_is_set as
well. This patch is master now, thanks.
