From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 1/2] Revert "conntrack: fix expectation entry
 creation"
Date: Wed, 20 Jan 2016 15:09:55 +0100
Message-ID: <20160120140955.GA441@salvia>
References: <1452887264-26064-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu, netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36256 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbcATOJ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 09:09:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C15AF3EBA8C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 15:09:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0FDADA85C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 15:09:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 637D2DA807
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 15:09:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452887264-26064-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 15, 2016 at 07:47:43PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> {} is mask-src and mask-dst, [] is tuple-src and tuple-dst
> mask-* should be stored in mask, tuple-* should be stored in exptuple=
=2E

Applied, thanks for fixing up this.

BTW, we have better tests under:

conntrack-tools/tests/conntrack/testsuite

I remember you also posted patches for:

http://patchwork.ozlabs.org/patch/428341/
http://patchwork.ozlabs.org/patch/428343/
http://patchwork.ozlabs.org/patch/428342/

It would be great if you can follow up on this, IIRC the only changed
I asked for is that it would be good to have test for this new
feature.

This has been in my TODO list for a while and I didn't find the time
to make it myself.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
