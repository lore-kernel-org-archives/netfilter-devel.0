From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 7/8] netfilter: prepare xt_cgroup for multi revisions
Date: Mon, 14 Dec 2015 20:35:31 +0100
Message-ID: <20151214193531.GA18238@salvia>
References: <1449527935-27056-1-git-send-email-tj@kernel.org>
 <1449527935-27056-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kaber@trash.net, kadlec@blackhole.kfki.hu,
	daniel@iogearbox.net, daniel.wagner@bmw-carit.de,
	nhorman@tuxdriver.com, lizefan@huawei.com, hannes@cmpxchg.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@fb.com, ninasc@fb.com,
	Jan Engelhardt <jengelh@inai.de>
To: Tejun Heo <tj@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46209 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbLNTff (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 14:35:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 56E018E7AF
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 20:35:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47E4FDA843
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 20:35:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 530A5DA843
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 20:35:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449527935-27056-8-git-send-email-tj@kernel.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 07, 2015 at 05:38:54PM -0500, Tejun Heo wrote:
> xt_cgroup will grow cgroup2 path based match.  Postfix existing
> symbols with _v0 and prepare for multi revision registration.

Applied, thanks.
