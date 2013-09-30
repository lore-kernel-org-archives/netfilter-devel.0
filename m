From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool - PATCH] include: Add proper nfnetlink header to
 fix compilation error
Date: Mon, 30 Sep 2013 12:48:38 +0200
Message-ID: <20130930104838.GA6086@localhost>
References: <1380532962-27411-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52811 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab3I3Kss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:48:48 -0400
Content-Disposition: inline
In-Reply-To: <1380532962-27411-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 12:22:42PM +0300, Tomasz Bursztyka wrote:
> Fixes:
> src/mnl.c: In function =E2=80=98mnl_batch_put=E2=80=99:
> src/mnl.c:117:16: error: =E2=80=98NFNL_SUBSYS_NFTABLES=E2=80=99 undec=
lared (first use in
> this function)
> src/mnl.c:117:16: note: each undeclared identifier is reported only o=
nce
> for each function it appears in
> src/mnl.c: In function =E2=80=98mnl_batch_begin=E2=80=99:
> src/mnl.c:125:16: error: =E2=80=98NFNL_MSG_BATCH_BEGIN=E2=80=99 undec=
lared (first use in
> this function)
> src/mnl.c: In function =E2=80=98mnl_batch_end=E2=80=99:
> src/mnl.c:130:16: error: =E2=80=98NFNL_MSG_BATCH_END=E2=80=99 undecla=
red (first use in
> this function)

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
