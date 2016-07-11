From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3, libnftnl] Fix nftnl_*_get to set data_len
Date: Mon, 11 Jul 2016 19:18:56 +0200
Message-ID: <20160711171856.GA13568@salvia>
References: <20160711114807.GA1788@salvia>
 <1468253260-9384-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbcGKRTJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 13:19:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 11F01C9EC3
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 19:19:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04DB9CA0FF
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 19:19:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DE659EBAA
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 19:19:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468253260-9384-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 11, 2016 at 06:07:40PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> All getters must set the output parameter 'data_len'

Applied.

Carlos, I have enhanced this description. Please, include more
detailed justifications on your follow up patches. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
