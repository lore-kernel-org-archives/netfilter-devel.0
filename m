From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] dist: include tests/ directory and files in tarball
Date: Thu, 28 Apr 2016 11:27:20 +0200
Message-ID: <20160428092720.GA1848@salvia>
References: <146183487873.3430.10556920470037312368.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34195 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbcD1J1Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 05:27:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6375315AEB0
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:27:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5292064481
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:27:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 40743ADDC
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:27:21 +0200 (CEST)
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
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  Makefile.am |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 068009b..10aa40f 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -4,3 +4,5 @@ SUBDIRS = 	src	\
>  		include	\
>  		doc	\
>  		files
> +
> +EXTRA_DIST =	tests

You can get a git clone instead?

This is going to bloat the tarball for something that only a few
developer need.
