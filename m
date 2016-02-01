From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 3/5] conntrack: cleanup: use switch statements
 for family checks
Date: Mon, 1 Feb 2016 12:02:52 +0100
Message-ID: <20160201110252.GG8095@salvia>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
 <1453720548-14413-3-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56379 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbcBALC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 06:02:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3471D2273C6
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:02:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 23AFFDA2D5
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:02:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D43B5DA243
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:02:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453720548-14413-3-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also applied, thanks a lot for following up on this Asbj=F8rn.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
