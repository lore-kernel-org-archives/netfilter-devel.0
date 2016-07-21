From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix test building on musl libc
Date: Thu, 21 Jul 2016 18:25:59 +0200
Message-ID: <20160721162559.GA10337@salvia>
References: <20160721041045.9986-1-somasissounds@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Kylie McClain <somasis@exherbo.org>
To: Kylie McClain <somasissounds@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58480 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbcGUQ0E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 12:26:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 35847210564
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:26:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1B1919EBD1
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:26:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 11BEDFF154
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:26:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160721041045.9986-1-somasissounds@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 21, 2016 at 12:10:45AM -0400, Kylie McClain wrote:
> From: Kylie McClain <somasis@exherbo.org>
> 
> On musl libc, sys/select.h is where FD_* definitions are located.

Applied, thanks.
