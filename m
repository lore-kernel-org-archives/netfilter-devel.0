From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3, libnftnl] expr: Fix lookup builder
Date: Fri, 12 Aug 2016 01:52:20 +0200
Message-ID: <20160811235220.GB5814@salvia>
References: <20160810151205.24975-1-carlosfg@riseup.net>
 <20160810151205.24975-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52814 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbcHKXwY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:52:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 129F71878C2
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04C9CDA7E7
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24F32DA7EA
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:52:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810151205.24975-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 05:12:04PM +0200, Carlos Falgueras García wrote:
> Deleted wrong braces that cause unwanted behaviour.

Applied, thanks.
