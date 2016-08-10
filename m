From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3, libnftnl] expr: Fix lookup builder
Date: Wed, 10 Aug 2016 18:48:58 +0200
Message-ID: <20160810164858.GB28006@salvia>
References: <20160810151205.24975-1-carlosfg@riseup.net>
 <20160810151205.24975-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47770 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbcHJSFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 956481D103B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 18:49:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 87F3F100A40
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 18:49:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1678100A5D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 18:48:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810151205.24975-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 05:12:04PM +0200, Carlos Falgueras García wrote:
> Deleted wrong braces that cause unwanted behaviour.

Also applied, thanks.
