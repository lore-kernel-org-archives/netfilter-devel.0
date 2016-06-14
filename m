From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 v2,libnftnl] Fix leak in nftnl_*_unset()
Date: Tue, 14 Jun 2016 17:43:29 +0200
Message-ID: <20160614154329.GA5622@salvia>
References: <20160610122246.1621-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60152 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbcFNPne (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 11:43:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7CC28C22E2
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:43:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6FCCA9EBA5
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:43:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 806FB9EBA5
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:43:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160610122246.1621-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, thanks Carlos.

