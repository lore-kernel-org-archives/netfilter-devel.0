From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] rule: Constify rule iterators
Date: Tue, 9 Aug 2016 09:17:04 +0200
Message-ID: <20160809071704.GB1866@salvia>
References: <20160808144834.GB6264@salvia>
 <20160808181016.4411-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33450 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbcHIHRQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 03:17:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7EA94A4167
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 09:17:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7078F1B332B
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 09:17:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6D4141B3245
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 09:17:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808181016.4411-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 08:10:16PM +0200, Carlos Falgueras García wrote:
> Iterators do not modify objects which they iterate, so input pointer must
> be const.

Please, constify other iterators: chain, set, set_elem, table, and so
on. So we get this code in sync too.

Thanks.
