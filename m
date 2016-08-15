From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 libnfntl] expr: cmp: Use cmp2str() instead of
 directly access to array
Date: Mon, 15 Aug 2016 13:49:24 +0200
Message-ID: <20160815114924.GB11239@salvia>
References: <20160815103256.GB5883@salvia>
 <20160815105103.22319-1-carlosfg@riseup.net>
 <20160815105103.22319-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44936 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbcHOLtd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 07:49:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 511FDA4179
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 13:49:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 42DC5CE156
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 13:49:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4539EA8249
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 13:49:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160815105103.22319-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 12:51:03PM +0200, Carlos Falgueras García wrote:
> Uses cmp2str() which checks array bounds.

Applied, thanks.
