From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] dist: include tests/ directory and files in tarball
Date: Fri, 29 Apr 2016 11:19:31 +0200
Message-ID: <20160429091931.GA12758@salvia>
References: <146183487873.3430.10556920470037312368.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56893 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbcD2JTm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:19:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 124BCC1255
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:19:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D763E100A78
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:19:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BFD2E100A54
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:19:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146183487873.3430.10556920470037312368.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 28, 2016 at 11:14:38AM +0200, Arturo Borrero Gonzalez wrote:
> If we include tests/ in the release tarball, downstream distributors
> can run the testsuites themselves while developing the packages.
> 
> This way, tests can be run in a more integrated environment and they can
> discover errors related to the integration with the given distribution itself.

Applied.
