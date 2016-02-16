From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 4/5 v2] conntrack: add support for netmask
 filtering
Date: Tue, 16 Feb 2016 19:18:17 +0100
Message-ID: <20160216181817.GA20397@salvia>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
 <1453720548-14413-4-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbcBPSSc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:18:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 717C91E11D3
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:18:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6295091DD
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:18:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 853A9ADCC
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:18:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453720548-14413-4-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 25, 2016 at 11:15:47AM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> This patch extends --mask-src and --mask-dst to also work
> with the conntrack table, with commands -L, -D, -E and -U.

Applied, thanks for your patience.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
