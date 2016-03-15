From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Shows proper function name for pr_debug() messages.
Date: Tue, 15 Mar 2016 01:15:01 +0100
Message-ID: <20160315001501.GA27056@salvia>
References: <20160314200733.GA8907@jwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Weongyo Jeong <weongyo.linux@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57219 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbcCOAPL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 20:15:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 03CE0114F43
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:15:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA762DA383
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:15:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 910B3DA38B
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:15:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160314200733.GA8907@jwg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 14, 2016 at 01:07:36PM -0700, Weongyo Jeong wrote:
> It seems pr_debug() calls didn't be updated while code was refactoring.

Better add:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

at the top of the file.

Have a look at beacd3e8ef23 ("netfilter: nfnetlink_log: Make use of
pr_fmt where applicable") for instance.
