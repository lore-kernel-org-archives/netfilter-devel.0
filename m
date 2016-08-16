From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3 v3 nft] tests: Use libnftnl comparators in all tests
Date: Tue, 16 Aug 2016 13:58:53 +0200
Message-ID: <20160816115853.GA2063@salvia>
References: <20160815122732.GA14674@salvia>
 <20160816103025.29380-1-carlosfg@riseup.net>
 <20160816103025.29380-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45008 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbcHPL7C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Aug 2016 07:59:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8A257186AC1
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 13:59:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 79437CE155
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 13:59:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 856DDCE156
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 13:58:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160816103025.29380-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 16, 2016 at 12:30:24PM +0200, Carlos Falgueras García wrote:
> Use 'nftnl_expr_cmp' and 'nftnl_rule_cmp' in all tests instead of custom
> comparator for each one. If objects differ both are printed.

Please, please. One at a time...

This depends on your previois patchset so I cannot take this patchset.
Sorry.
