From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 1/4] conntrack: split up
 nfct_set_addr_from_opt()
Date: Tue, 16 Feb 2016 19:18:50 +0100
Message-ID: <20160216181850.GC20397@salvia>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38167 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbcBPSS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:18:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B724F1E11D6
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:18:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A7E22ADE5
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:18:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 225E222014
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:18:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 01:30:04PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Prepare for CIDR support, by splitting nfct_set_addr_from_opt()
> into nfct_parse_addr_from_opt() for parsing
> and nfct_set_addr_opt() for storing.

Applied, thanks.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
