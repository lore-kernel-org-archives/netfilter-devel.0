From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 2/4 v2] conntrack: extend parse_addr() with
 CIDR support
Date: Tue, 16 Feb 2016 19:19:02 +0100
Message-ID: <20160216181902.GD20397@salvia>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
 <1454333407-6335-2-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbcBPSTO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:19:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 496351E11DE
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:19:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3B08991DD
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:19:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 67B0BADE5
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:19:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454333407-6335-2-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, thanks.
