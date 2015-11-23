From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: move ip_ct_sctp away from UAPI
Date: Mon, 23 Nov 2015 17:56:21 +0100
Message-ID: <20151123165621.GA6375@salvia>
References: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbbKWQ40 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 11:56:26 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5E6B26E411
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 17:56:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4DEB0DA864
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 17:56:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E69FDDA7FF
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 17:56:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 11, 2015 at 08:17:37PM -0200, Marcelo Ricardo Leitner wrote:
> ip_ct_sctp is an internal structure, embedded by the union
> nf_conntrack_proto to store sctp-specific information at conntrack
> entries. It has no business with UAPI.
> 
> This patch moves it from UAPI to a saner place, together with similar
> structs for other protocols.

Applied, thanks.
