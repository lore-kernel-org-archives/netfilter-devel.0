From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4 v6] libnftnl: test: Update test to check new
 nftnl_udata features of nftnl_rule
Date: Thu, 14 Apr 2016 02:00:03 +0200
Message-ID: <20160414000003.GB12737@salvia>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
 <1458675987-32398-3-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44473 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbcDNAAM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 20:00:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D234273F3
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 02:00:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C5368ADF8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 02:00:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2951EA868
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 02:00:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458675987-32398-3-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 08:46:26PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> Modify nft-rule-test.c to check TLV attribute inclusion in nftnl_rule=
=2E

Applied, thanks.

> Add "*-rule-udata.[json|xml]" to check parsers.

I have removed the xml,json chunks, given I kept back 2/4.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
