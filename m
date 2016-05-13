From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3] tests/shell: add testcase to catch segfault if
 invalid syntax was used
Date: Fri, 13 May 2016 11:40:32 +0200
Message-ID: <20160513094032.GC4008@salvia>
References: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
 <146296621327.3706.18265491927507888269.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbcEMJkh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 05:40:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C41644B0EB
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:40:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B2EB42687D8
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:40:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B2F462687DC
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:40:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146296621327.3706.18265491927507888269.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 11, 2016 at 01:30:13PM +0200, Arturo Borrero Gonzalez wrote:
> Let's add

Applied.

I have included in the commit log message that this refers to
"evaluate: check for NULL datatype in rhs in lookup expr".
