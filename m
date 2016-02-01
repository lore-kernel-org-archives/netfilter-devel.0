From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 1/4] tests: conntrack: run testfiles in the
 correct order
Date: Mon, 1 Feb 2016 11:59:33 +0100
Message-ID: <20160201105933.GA8095@salvia>
References: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbcBAK7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 05:59:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F119F61E8D
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 11:59:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0079DA860
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 11:59:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAAF5DA795
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 11:59:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 25, 2016 at 10:40:27AM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Use scandir(3) instead of opendir(3), so that the tests are
> run in the expected order, otherwise it doesn't make
> sense to prefix the testfiles with a two digit number,
> giving the impression that they are run in order.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
