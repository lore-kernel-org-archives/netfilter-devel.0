From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft 0/6] flow statement
Date: Mon, 16 Nov 2015 14:00:27 +0100
Message-ID: <20151116130027.GA1057@salvia>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41163 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbKPNAg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 08:00:36 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B59926E418
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 14:00:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A18D1178907
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 14:00:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01C44178904
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 14:00:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Fri, Nov 06, 2015 at 06:34:17PM +0000, Patrick McHardy wrote:
> # nft filter input flow table test iif . tcp flags counter
> # nft filter output flow table uidacct skuid . oif . ip protocol counter

Probably we can enclose the table definition in brackets? ie.

# nft filter output flow table uidacct { skuid . oif . ip protocol counter }

Thus the user becomes aware that any follow up statement applies
globally to the rule.

At this stage we only have one expression, but maybe in the future we
extend the flow table to support more that one stateful expression,
then we may have problems with this syntax.

Let me know, thanks.
