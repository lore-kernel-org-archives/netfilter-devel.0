From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: Uses pr_fmt() for logging.
Date: Tue, 29 Mar 2016 13:10:21 +0200
Message-ID: <20160329111021.GA12432@salvia>
References: <20160315175741.GA11458@jwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Weongyo Jeong <weongyo.linux@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbcC2LK2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:10:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 101C6843B
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:10:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B8164DA3AA
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:10:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B9DD9E1506
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:10:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160315175741.GA11458@jwg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 10:57:44AM -0700, Weongyo Jeong wrote:
> Uses pr_fmt() macro for debugging messages of nf_conntrack module.

Applied, thanks.
