From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ctnetlink: add expectation deletion events
Date: Fri, 15 Oct 2010 17:44:21 +0200
Message-ID: <4CB876D5.208@trash.net>
References: <20101014120209.3062.89240.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51698 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0JOPon (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:44:43 -0400
In-Reply-To: <20101014120209.3062.89240.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.10.2010 14:02, schrieb Pablo Neira Ayuso:
> This patch allows to listen to events that inform about
> expectations destroyed.

This looks fine, but I'm wondering why we're not delivering
events for expectations created and destroyed by helpers using
nf_conntrack_expect_related()/nf_conntrack_unexpect_related().
