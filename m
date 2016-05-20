From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_conntrack PATCH v2 2/3] src: add support for IPv6
 NAT
Date: Fri, 20 May 2016 11:36:09 +0200
Message-ID: <20160520093609.GA2276@salvia>
References: <146356174434.15746.15408366557914731507.stgit@nfdev2.cica.es>
 <146356178539.15746.14120866742567536066.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32783 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbcETJgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 05:36:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E2EC7C9EE0
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:36:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C734415D63F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:36:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47ACD15D62E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:36:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146356178539.15746.14120866742567536066.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 18, 2016 at 10:56:36AM +0200, Arturo Borrero Gonzalez wrote:
> The conntrackd daemon lacks support for syncing IPv6 NATed connections.
> 
> This patch adds support for managing the IPv6 part of struct __nfct_nat,
> also updating the corresponsing symbols.

Also applied, thanks.
