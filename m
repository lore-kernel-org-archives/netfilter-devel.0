Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32035C43333
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B2960233
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353428AbhCDAEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:04:43 -0500
Received: from correo.us.es ([193.147.175.20]:60290 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240137AbhCCQe0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 11:34:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CE5D1F0CED
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:33:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C94DDA730
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:33:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 817B3DA78B; Wed,  3 Mar 2021 17:33:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BFEFDA730;
        Wed,  3 Mar 2021 17:33:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Mar 2021 17:33:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1CBCD42DF561;
        Wed,  3 Mar 2021 17:33:23 +0100 (CET)
Date:   Wed, 3 Mar 2021 17:33:22 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     linuxludo@free.fr
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module
Message-ID: <20210303163322.GA17445@salvia>
References: <1524997693.135804496.1614764827412.JavaMail.root@zimbra63-e11.priv.proxad.net>
 <471218486.135924319.1614766871068.JavaMail.root@zimbra63-e11.priv.proxad.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <471218486.135924319.1614766871068.JavaMail.root@zimbra63-e11.priv.proxad.net>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Mar 03, 2021 at 11:21:11AM +0100, linuxludo@free.fr wrote:
> Dear,
> 
> I would provide you a small patch in order to fix a BUG when GRE over IPv6 is used with netfilter/conntrack module.
> 
> This is my first contribution, not knowing the procedure well, thank you for being aware of this request.
> 
> Regarding the proposed patch, here is a description of the encountered bug.
> Indeed, when an ip6tables rule dropping traffic due to an invalid packet (aka w/ conntrack module) is placed before a GRE protocol permit rule, the latter is never reached ; the packet is discarded via the previous rule. 
> 
> The proposed patch takes into account both IPv4 and IPv6 in conntrack module for GRE protocol.
> You will find this one at the end of this email.

The GRE protocol helper is tied to the PPTP conntrack helper which
does not support for IPv6. How are you using this update in your
infrastructure?

Thanks.

> --- nf_conntrack_proto_gre.c.orig       2021-03-03 05:03:37.034665100 -0500
> +++ nf_conntrack_proto_gre.c    2021-03-02 17:42:53.000000000 -0500
> @@ -219,7 +219,7 @@ int nf_conntrack_gre_packet(struct nf_co
>                             enum ip_conntrack_info ctinfo,
>                             const struct nf_hook_state *state)
>  {
> -       if (state->pf != NFPROTO_IPV4)
> +       if (state->pf != NFPROTO_IPV4 && state->pf != NFPROTO_IPV6)
>                 return -NF_ACCEPT;
> 
>         if (!nf_ct_is_confirmed(ct)) {
> 
