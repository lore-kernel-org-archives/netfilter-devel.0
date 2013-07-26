From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 1/5] nft: let nft_handle struct own the
 builtin table pointer
Date: Fri, 26 Jul 2013 14:31:52 +0200
Message-ID: <20130726123152.GA3762@localhost>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57101 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab3GZMcJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:32:09 -0400
Content-Disposition: inline
In-Reply-To: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 26, 2013 at 01:05:15PM +0200, Giuseppe Longo wrote:
> The following patch adds own builtin_table pointer used by future too=
l (like arptables)
> to have own tables and not tables declared in nft.c

If I apply this patch and if I type 'make', it says:

nft.c: In function =E2=80=98nft_table_builtin_find=E2=80=99:
nft.c:297:7: error: =E2=80=98tables=E2=80=99 undeclared (first use in t=
his function)
nft.c:297:7: note: each undeclared identifier is reported only once for=
 each function it appears in
nft.c:297:7: warning: left-hand operand of comma expression has no effe=
ct [-Wunused-value]
nft.c:297:7: warning: value computed is not used [-Wunused-value]
nft.c:297:7: warning: left-hand operand of comma expression has no effe=
ct [-Wunused-value]
mv -f .deps/xtables_multi-iptables.Tpo .deps/xtables_multi-iptables.Po
mv -f .deps/xtables_multi-xtables-config-parser.Tpo
=2Edeps/xtables_multi-xtables-config-parser.Po
nft.c:305:1: warning: control reaches end of non-void function [-Wretur=
n-type]
make[2]: *** [xtables_multi-nft.o] Error 1

Patches have to leave the repository in a consistency state, ie.
compilation/operational should not break between patches, at least not
voluntarily. This usually means that you're incorrectly splitting the
patches. I have merged 1/5 and 2/5 into one single patch and push it
into master. Thanks Giuseppe.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
