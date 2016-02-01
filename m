From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: netlink_linearize: Fix bug for redirect target
Date: Mon, 1 Feb 2016 15:09:45 +0100
Message-ID: <20160201140945.GA4809@salvia>
References: <20160128193537.GA23701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58477 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbcBAOJt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 09:09:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8242B333
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 15:09:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 708EDDA803
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 15:09:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92C18DA795
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 15:09:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160128193537.GA23701@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 29, 2016 at 01:05:37AM +0530, Shivani Bhardwaj wrote:
> Before this patch,
> $ sudo nft --debug=netlink add rule ip nat post ip protocol tcp redirect to 100-200
> ip nat post
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ immediate reg 1 0x00006400 ]
>   [ immediate reg 2 0x0000c800 ]
>   [ redir proto_min reg 1 proto_max reg 5 ]
> 
> <cmdline>:1:1-56: Error: Could not process rule: Invalid argument
> add rule ip nat post ip protocol tcp redirect to 100-200
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> After this patch,
> $ sudo nft --debug=netlink add rule ip nat post ip protocol tcp redirect to 100-200
> ip nat post
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ immediate reg 1 0x00006400 ]
>   [ immediate reg 2 0x0000c800 ]
>   [ redir proto_min reg 1 proto_max reg 2 ]

Shivani, this is a very good catch. Applied, thanks!

