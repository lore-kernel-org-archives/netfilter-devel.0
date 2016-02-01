From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 4/4] tests: conntrack: use local conntrack
 binary
Date: Mon, 1 Feb 2016 12:00:33 +0100
Message-ID: <20160201110033.GD8095@salvia>
References: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
 <1453718430-5784-4-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55147 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbcBALAl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 06:00:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 29DBF61E8E
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:00:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 15029DA814
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:00:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AF16DDA843
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 12:00:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453718430-5784-4-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 25, 2016 at 10:40:30AM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> The binary under test should be the one, this ensures
> that it is in sync with the tests performed, and that
> users who build from source, can test the binary prior
> to `make install`.
>=20
> Signed-off-by: Asbj=F8rn Sloth T=F8nnesen <ast@fiberby.dk>
> ---
>=20
> This is my preference, others might prefer it as it is.
> Maybe it should be possible to overwrite with an
> enviromental variable or an argument, currently test-conntrack.c
> doesn't take any arguments, but run-tests.sh passes the
> testdir as an argument.

I agree it makes sense to test what you have in your tree without
having to install it.

Applied, thanks!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
