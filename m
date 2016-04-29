From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] dist: include tests/ directory and files
 in tarball
Date: Fri, 29 Apr 2016 11:19:45 +0200
Message-ID: <20160429091945.GB12758@salvia>
References: <146183487005.3278.11126686560647444846.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56963 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbcD2JTy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:19:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 934C2C1255
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:19:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 858A3FEFBF
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:19:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 77A61100A4E
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:19:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146183487005.3278.11126686560647444846.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 28, 2016 at 11:14:30AM +0200, Arturo Borrero Gonzalez wrote:
> If we include tests/ in the release tarball, downstream distributors
> can run the testsuites themselves while developing the packages.
> 
> This way, tests can be run in a more integrated environment and they can
> discover errors related to the integration with the given distribution itself.
> 

Also applied.
