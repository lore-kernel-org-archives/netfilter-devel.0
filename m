From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] conntrackd: add support for
 NTA_(S|D)NAT_IPV6
Date: Fri, 20 May 2016 11:37:05 +0200
Message-ID: <20160520093705.GB2276@salvia>
References: <146359111275.1329.5525714829523602554.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33398 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbcETJhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 05:37:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B0B6FC9EE0
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:37:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9E88EADE9
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:37:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAD10ADE9
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:37:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146359111275.1329.5525714829523602554.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 18, 2016 at 07:05:12PM +0200, Arturo Borrero Gonzalez wrote:
> So we can properly sync NATed IPv6 connections.

Applied, thanks.

