From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions/libxt_tcp: fix nftables translate
 flags value, 'none' vs '0x0'
Date: Thu, 7 Apr 2016 11:47:21 +0200
Message-ID: <20160407094721.GA2478@salvia>
References: <145994465193.22717.2137088538000837721.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@mva.name
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbcDGJr1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:47:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B8FF3C125A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:47:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AB674DA39D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:47:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8998BDA394
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:47:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <145994465193.22717.2137088538000837721.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 06, 2016 at 02:10:52PM +0200, Arturo Borrero Gonzalez wrote:
> The iptables command:
>  -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE
> 
> should translate to:
>  tcp flags & fin|syn|rst|psh|ack|urg == 0x0
> 
> instead of:
>  tcp flags & fin|syn|rst|psh|ack|urg == none

Applied, thanks.
