From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3] tests/shell: add testcases for Netfilter bug #965
Date: Wed, 13 Apr 2016 01:29:48 +0200
Message-ID: <20160412232948.GA21605@salvia>
References: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
 <145873750378.10004.16685712526295738112.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38082 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879AbcDLXaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 19:30:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CD8CAC9EE1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:30:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF250C21A1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:30:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C6DD2C21A1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:30:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <145873750378.10004.16685712526295738112.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 23, 2016 at 01:51:43PM +0100, Arturo Borrero Gonzalez wrote:
> Testscases for Netfilter bug #965:
>  * add rule at position
>  * insert rule at position
>  * replace rule with given handle
>  * delete rule with given handle
>  * don't allow to delete rules with position keyword

Please, resubmit this now that we got the fix into master.

Thanks Arturo.
