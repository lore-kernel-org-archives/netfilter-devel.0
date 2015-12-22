From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: prepare xt_cgroup for multi revisions
Date: Tue, 22 Dec 2015 19:22:45 +0100
Message-ID: <20151222182245.GA22899@salvia>
References: <20151221215302.GT4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49406 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933035AbbLVS3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 13:29:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7BD6723CF6B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 19:29:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6C16ADA80D
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 19:29:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2E8A7DA7E0
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 19:29:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151221215302.GT4026@mtj.duckdns.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 21, 2015 at 04:53:02PM -0500, Tejun Heo wrote:
> xt_cgroup will grow cgroup2 path based match.  Postfix existing
> symbols with _v0 and prepare for multi revision registration.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> CC: Neil Horman <nhorman@tuxdriver.com>
> Cc: Jan Engelhardt <jengelh@inai.de>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hello,
> 
> This is the userspace part of cgroup2 support in xt_cgroup.
> 
>  http://lkml.kernel.org/g/1449527935-27056-1-git-send-email-tj@kernel.org

Tejun, this patchset doesn't contain the userspace bits, this looks
like you're resending kernel patches.
