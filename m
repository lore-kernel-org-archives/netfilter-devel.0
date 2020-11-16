Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6C0C4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 03:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 049E720773
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 03:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKPD6h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Nov 2020 22:58:37 -0500
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:35450 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726532AbgKPD6h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 22:58:37 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5630C1730858;
        Mon, 16 Nov 2020 03:58:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: scent45_491207927325
X-Filterd-Recvd-Size: 2428
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Mon, 16 Nov 2020 03:58:34 +0000 (UTC)
Message-ID: <d03c87f9fcc4bb68c148cfad12cafef5f2385eef.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: rectify file patterns for NETFILTER
From:   Joe Perches <joe@perches.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 15 Nov 2020 19:58:33 -0800
In-Reply-To: <20201109091942.32280-1-lukas.bulwahn@gmail.com>
References: <20201109091942.32280-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2020-11-09 at 10:19 +0100, Lukas Bulwahn wrote:
> The two file patterns in the NETFILTER section:
> 
>   F:      include/linux/netfilter*
>   F:      include/uapi/linux/netfilter*
> 
> intended to match the directories:
> 
>   ./include{/uapi}/linux/netfilter_{arp,bridge,ipv4,ipv6}
> 
> A quick check with ./scripts/get_maintainer.pl --letters -f will show that
> they are not matched, though, because this pattern only matches files, but
> not directories.
> 
> Rectify the patterns to match the intended directories.
[]
diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -12139,10 +12139,10 @@ W:	http://www.nftables.org/
>  Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
> -F:	include/linux/netfilter*
> +F:	include/linux/netfilter*/
>  F:	include/linux/netfilter/

This line could be deleted or perhaps moved up one line above

F:	include/linux/netfilter/
F:	include/linux/netfilter*/

(as the second line already matches the first line's files too)

>  F:	include/net/netfilter/
> -F:	include/uapi/linux/netfilter*
> +F:	include/uapi/linux/netfilter*/
>  F:	include/uapi/linux/netfilter/

same here.

>  F:	net/*/netfilter.c
>  F:	net/*/netfilter/


