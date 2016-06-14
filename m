From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 v2,libnftnl] Check memory allocations in setters
Date: Tue, 14 Jun 2016 17:50:03 +0200
Message-ID: <20160614155003.GA6799@salvia>
References: <20160610122246.1621-1-carlosfg@riseup.net>
 <20160610122246.1621-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33243 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcFNPuQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 11:50:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 806EFC22E3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:50:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 717E49EBA8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:50:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E596A9EBAF
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:50:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160610122246.1621-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 10, 2016 at 02:22:46PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> When you set an object attribute the memory is copied, sometimes an
> allocations is needed and it must be checked. Before this patch all s=
etters
> method return void, so this patch makes all setters return int instea=
d void
> to communicate the error to user.

This one triggered the large patcheset I just posted on the list.

Thanks anyway.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
