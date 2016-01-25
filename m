From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: fix cgroup2 help message in libxt_cgroup.c.
Date: Mon, 25 Jan 2016 11:20:49 +0100
Message-ID: <20160125102049.GA1776@salvia>
References: <1453702179-21590-1-git-send-email-rami.rosen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, tj@kernel.org, dborkman@redhat.com,
	jengelh@inai.de, netfilter-devel@vger.kernel.org
To: Rami Rosen <rami.rosen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35646 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbcAYKU6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 05:20:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 998DF2791A8
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2016 11:20:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 86C5ADA808
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2016 11:20:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0B68DA85F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2016 11:20:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453702179-21590-1-git-send-email-rami.rosen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 25, 2016 at 08:09:39AM +0200, Rami Rosen wrote:
> This patch fixes a typo in the cgroup2 cgroup_help_v1() method in extensions\ibxt_cgroup.c.

Applied, thanks Rami.

P.S: Please next time submit your patch to
netfilter-devel@vger.kernel.org.
