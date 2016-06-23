From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/3] libxt_hashlimit: Prepare libxt_hashlimit.c
 for revision 2
Date: Thu, 23 Jun 2016 12:40:12 +0200
Message-ID: <20160623104012.GB10493@salvia>
References: <20160602001628.GD1644@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	johunt@akamai.com, netdev@vger.kernel.org, pai.vishwain@gmail.com
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48560 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbcFWKkV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:40:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 03E67E7DB6
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:40:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCB409EBAD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:40:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C74489EBAD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:40:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160602001628.GD1644@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not specifically related to this patch.

It would be great if you can send us a patch to add new tests to
iptables/extensions/libxt_hashlimit.t for this new higher resolution
pps ratelimit.

Thanks!
