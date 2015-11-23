From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] src: fix build with musl libc
Date: Mon, 23 Nov 2015 12:07:09 +0100
Message-ID: <20151123110709.GA5682@salvia>
References: <1448254789-30961-1-git-send-email-rprebello@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Rodrigo Rebello <rprebello@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43990 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbbKWLHL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 06:07:11 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7BBFE18CDC2
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 12:07:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 64DC7DA801
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 12:07:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 819BCDA874
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 12:07:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448254789-30961-1-git-send-email-rprebello@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 23, 2015 at 02:59:49AM -0200, Rodrigo Rebello wrote:
> The GNU version of 'struct tcphdr' is not exposed by musl libc headers
> unless _GNU_SOURCE is defined. Without this definition, the build fails
> with:
> 
>   rpc.c: In function 'rpc_helper_cb':
>   rpc.c:351:15: error: 'struct tcphdr' has no member named 'doff'
>      offset += th->doff * 4;
>                  ^

You can probably update the code to use the non-GNU version, that
should work both with musl, libc and any other new version that
sticks to the standard.

Thanks.
