From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: add testcases for Netfilter bug #965
Date: Fri, 15 Apr 2016 12:39:38 +0200
Message-ID: <20160415103938.GA10582@salvia>
References: <146062067574.20303.17765460378437095142.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33045 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbcDOKjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:39:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 80795FF14D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:39:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7109FEBADB
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:39:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7FE58FAB45
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:39:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146062067574.20303.17765460378437095142.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 09:58:56AM +0200, Arturo Borrero Gonzalez wrote:
> Testscases for Netfilter bug #965:
>  * add rule at position
>  * insert rule at position
>  * replace rule with given handle
>  * delete rule with given handle
>  * don't allow to delete rules with position keyword

Applied, thanks.
