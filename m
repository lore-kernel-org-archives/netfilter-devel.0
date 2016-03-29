From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v6 1/3] netfilter: bridge: add nf_afinfo to
 enable queuing to userspace
Date: Tue, 29 Mar 2016 13:02:10 +0200
Message-ID: <20160329110210.GA10650@salvia>
References: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35039 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbcC2LCT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:02:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 90E108420
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:02:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4FBE6DA383
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:02:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0C3DFDA3A2
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:02:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 26, 2016 at 08:42:10AM +0100, Stephane Bryant wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> This just adds and registers a nf_afinfo for the ethernet
> bridge, which enables queuing to userspace for the AF_BRIDGE
> family. No checksum computation is done.

Applied, thanks Stephane.
