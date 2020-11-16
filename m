Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFDCC4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 10:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0BF9216C4
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 10:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgKPJnD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:43:03 -0500
Received: from correo.us.es ([193.147.175.20]:51662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgKPJnC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 04:43:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9FFFFD2DA2E
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 10:42:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 844307CC8B
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 10:42:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C72951B57DD; Mon, 16 Nov 2020 10:39:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1931523B9D8;
        Mon, 16 Nov 2020 10:17:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 10:17:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CF2AE4265A5A;
        Mon, 16 Nov 2020 10:17:36 +0100 (CET)
Date:   Mon, 16 Nov 2020 10:17:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Joe Perches <joe@perches.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: rectify file patterns for NETFILTER
Message-ID: <20201116091736.GA32490@salvia>
References: <20201109091942.32280-1-lukas.bulwahn@gmail.com>
 <d03c87f9fcc4bb68c148cfad12cafef5f2385eef.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d03c87f9fcc4bb68c148cfad12cafef5f2385eef.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lukas,

On Sun, Nov 15, 2020 at 07:58:33PM -0800, Joe Perches wrote:
> On Mon, 2020-11-09 at 10:19 +0100, Lukas Bulwahn wrote:
> > The two file patterns in the NETFILTER section:
> > 
> >   F:      include/linux/netfilter*
> >   F:      include/uapi/linux/netfilter*
> > 
> > intended to match the directories:
> > 
> >   ./include{/uapi}/linux/netfilter_{arp,bridge,ipv4,ipv6}
> > 
> > A quick check with ./scripts/get_maintainer.pl --letters -f will show that
> > they are not matched, though, because this pattern only matches files, but
> > not directories.
> > 
> > Rectify the patterns to match the intended directories.
> []
> diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -12139,10 +12139,10 @@ W:	http://www.nftables.org/
> >  Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
> > -F:	include/linux/netfilter*
> > +F:	include/linux/netfilter*/
> >  F:	include/linux/netfilter/
> 
> This line could be deleted or perhaps moved up one line above
> 
> F:	include/linux/netfilter/
> F:	include/linux/netfilter*/
> 
> (as the second line already matches the first line's files too)
> 
> >  F:	include/net/netfilter/
> > -F:	include/uapi/linux/netfilter*
> > +F:	include/uapi/linux/netfilter*/
> >  F:	include/uapi/linux/netfilter/
> 
> same here.
> 
> >  F:	net/*/netfilter.c
> >  F:	net/*/netfilter/

Please, send a v2 to address this feedback. Thank you.
