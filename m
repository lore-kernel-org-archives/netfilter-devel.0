From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH, v2] Constify iterators
Date: Wed, 10 Aug 2016 10:30:59 +0200
Message-ID: <20160810083059.GA21080@salvia>
References: <20160809071704.GB1866@salvia>
 <20160809114217.16093-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57102 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650AbcHJTKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:10:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0AFF0A4172
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:31:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EE052FF2D6
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:31:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F3738FAB5F
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:31:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160809114217.16093-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 09, 2016 at 01:42:17PM +0200, Carlos Falgueras García wrote:
> Iterators do not modify objects which they iterate, so input pointer must
> be const.

Applied, thanks!
