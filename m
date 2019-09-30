Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C359C32792
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 16:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED7C62168B
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 16:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbfI3Qbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 12:31:39 -0400
Received: from correo.us.es ([193.147.175.20]:45726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731976AbfI3Qbj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 12:31:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 452364A7077
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 18:31:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37537A7EC5
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 18:31:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 36A9EA7EC2; Mon, 30 Sep 2019 18:31:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2001CFF2E8;
        Mon, 30 Sep 2019 18:31:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Sep 2019 18:31:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F29A342EF9E4;
        Mon, 30 Sep 2019 18:31:32 +0200 (CEST)
Date:   Mon, 30 Sep 2019 18:31:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 17/24] xtables-restore: Carry in_table in
 struct nft_xt_restore_parse
Message-ID: <20190930163134.ypt64m56qfzmadjs@salvia>
References: <20190925212605.1005-1-phil@nwl.cc>
 <20190925212605.1005-18-phil@nwl.cc>
 <20190930163053.m4vlsfmgjrp6jifo@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7oj22uhmyshdr5pg"
Content-Disposition: inline
In-Reply-To: <20190930163053.m4vlsfmgjrp6jifo@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--7oj22uhmyshdr5pg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2019 at 06:30:53PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 25, 2019 at 11:25:58PM +0200, Phil Sutter wrote:
> > This is a requirement for outsourcing line parsing code into a dedicated
> > function.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  iptables/nft-shared.h      |  1 +
> >  iptables/xtables-restore.c | 17 ++++++++---------
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> > index 9d62913461fa4..facad6d02a7ec 100644
> > --- a/iptables/nft-shared.h
> > +++ b/iptables/nft-shared.h
> > @@ -237,6 +237,7 @@ struct nft_xt_restore_parse {
> >  	int		testing;
> >  	const char	*tablename;
> >  	bool		commit;
> > +	bool		in_table;
> 
> I don't think this belong here.
> 
> If you want to add a structure, then add something like:
> 
> struct nft_xt_parse_ctx {
>         char    buffer[10240];
>         char    *curtable;
>         int     in_table;
> };
> 
> to store all the internal context, not mix things like internal
> parsing context with the object that describes the parser
> configuration.

Attaching a patch to constify nft_xt_restore_parse.

--7oj22uhmyshdr5pg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index de889ead7b60..ea9e5bfa6ae1 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -261,7 +261,7 @@ struct nft_xt_restore_cb {
 };
 
 void xtables_restore_parse(struct nft_handle *h,
-			   struct nft_xt_restore_parse *p,
+			   const struct nft_xt_restore_parse *p,
 			   struct nft_xt_restore_cb *cb,
 			   int argc, char *argv[]);
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 601c842feab3..d34fad43e0b3 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -85,7 +85,7 @@ static const struct xtc_ops xtc_ops = {
 };
 
 void xtables_restore_parse(struct nft_handle *h,
-			   struct nft_xt_restore_parse *p,
+			   const struct nft_xt_restore_parse *p,
 			   struct nft_xt_restore_cb *cb,
 			   int argc, char *argv[])
 {

--7oj22uhmyshdr5pg--
