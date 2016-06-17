From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: Fix logic for flex version check
Date: Fri, 17 Jun 2016 13:00:53 +0200
Message-ID: <20160617110053.GA3372@salvia>
References: <1466114774-1831-1-git-send-email-shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42433 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbcFQLBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 07:01:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 07E6F302452
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:00:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E6BF464476
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:00:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 869651150DA
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:00:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466114774-1831-1-git-send-email-shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Shivani,

On Fri, Jun 17, 2016 at 03:36:14AM +0530, Shivani Bhardwaj wrote:
> According to the previous logic of version check for flex, anything
> greater than 2.5.33 but within 2.5.x was acceptable. The issue was
> observed when a false warning generated for flex version 2.6.0.
> New logic works for basically everything greater than 2.5.33.

The patch doesn't say what tree this patch is intended for.

Anyway, this idiom has been copy and pasted from other netfilter
trees so it would be good to check if conntrack-tools, iptables and
nft suffer from this problem that you describe above.

Please, resubmit including prefix, eg. [PATCH iptables] configure: ...
and let me know, thanks.
