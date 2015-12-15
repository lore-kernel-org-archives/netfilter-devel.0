From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] tests/: rearrange tests directory
Date: Tue, 15 Dec 2015 21:37:22 +0100
Message-ID: <20151215203722.GA11402@salvia>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
 <144982861420.31246.5857618349281263108.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965274AbbLOUha (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2015 15:37:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0EADB6BB0
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 21:37:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B25FBDA801
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 21:37:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2D42ADA809
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 21:37:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <144982861420.31246.5857618349281263108.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 11, 2015 at 11:10:14AM +0100, Arturo Borrero Gonzalez wrote:
> Rearrange the directory to obtain a better organization of files and
> tests-suites.
> 
> We end with a tree like this:
> 
> tests
>   |
>   .--- py
>   .--- shell
>   .--- files

Applied, thanks Arturo.
