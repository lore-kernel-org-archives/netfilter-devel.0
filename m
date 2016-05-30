From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 libnftnl] set_elem: Copy user data memory
Date: Mon, 30 May 2016 11:46:47 +0200
Message-ID: <20160530094647.GA29143@salvia>
References: <1464361015-14755-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40947 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbcE3Jq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:46:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 79E2F1D92C2
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:46:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 69C5A15D639
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:46:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 870C615D62D
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:46:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464361015-14755-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 27, 2016 at 04:56:54PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> All attributes are passed by copy, so user data should be copied too.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
