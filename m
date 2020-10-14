Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803DBC433E7
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 13:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C75820848
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 13:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgJNNBU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 09:01:20 -0400
Received: from correo.us.es ([193.147.175.20]:34750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgJNNBU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 09:01:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2FFB0FC5EB
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 15:01:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21A01DA78E
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 15:01:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16727DA73F; Wed, 14 Oct 2020 15:01:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2757DA73F;
        Wed, 14 Oct 2020 15:01:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 15:01:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C53C24301DE2;
        Wed, 14 Oct 2020 15:01:15 +0200 (CEST)
Date:   Wed, 14 Oct 2020 15:01:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: iptables userspace API broken due to added value in nf_inet_hooks
Message-ID: <20201014130115.GA21886@salvia>
References: <CAHmME9q_ExkdWXg6TMRnhwp7KGRQExooiP-jdpXiPqc=s1p4SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9q_ExkdWXg6TMRnhwp7KGRQExooiP-jdpXiPqc=s1p4SA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 14, 2020 at 02:59:47PM +0200, Jason A. Donenfeld wrote:
> Hey Pablo,
> 
> In 60a3815da702fd9e4759945f26cce5c47d3967ad, you added another enum
> value to nf_inet_hooks:
> 
> --- a/include/uapi/linux/netfilter.h
> +++ b/include/uapi/linux/netfilter.h
> @@ -45,6 +45,7 @@ enum nf_inet_hooks {
>        NF_INET_FORWARD,
>        NF_INET_LOCAL_OUT,
>        NF_INET_POST_ROUTING,
> +       NF_INET_INGRESS,
>        NF_INET_NUMHOOKS
> };
> 
> That seems fine, but actually it changes the value of
> NF_INET_NUMHOOKS, which is used in struct ipt_getinfo:
> 
> /* The argument to IPT_SO_GET_INFO */
> struct ipt_getinfo {
>        /* Which table: caller fills this in. */
>        char name[XT_TABLE_MAXNAMELEN];
> 
>        /* Kernel fills these in. */
>        /* Which hook entry points are valid: bitmask */
>        unsigned int valid_hooks;
> 
>        /* Hook entry points: one per netfilter hook. */
>        unsigned int hook_entry[NF_INET_NUMHOOKS];
> 
>        /* Underflow points. */
>        unsigned int underflow[NF_INET_NUMHOOKS];
> 
>        /* Number of entries */
>        unsigned int num_entries;
> 
>        /* Size of entries. */
>        unsigned int size;
> };
> 
> This in turn makes that struct bigger, which means this check in
> net/ipv4/netfilter/ip_tables.c fails:
> 
> static int get_info(struct net *net, void __user *user, const int *len)
> {
>        char name[XT_TABLE_MAXNAMELEN];
>        struct xt_table *t;
>        int ret;
> 
>        if (*len != sizeof(struct ipt_getinfo))
>                return -EINVAL;
> 
> This is affecting my CI, which attempts to use an older iptables with
> net-next and fails with:
> 
> iptables v1.8.4 (legacy): can't initialize iptables table `filter':
> Module is wrong version
> Perhaps iptables or your kernel needs to be upgraded.
> 
> Is this kind of breakage okay? If there's an exception carved out for
> breaking the iptables API, just let me know, and I'll look into making
> adjustments to work around it in my CI. On the other hand, if this
> breakage was unintentional, now you know.

Oh right, I'll need a new IPT_INET_NUMHOOKS for this.

I'll submit a patch, that's for the heads up.
