Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD66CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C68220700
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfJVReR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 13:34:17 -0400
Received: from correo.us.es ([193.147.175.20]:59170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbfJVReQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 13:34:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 412D0E2C54
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 19:34:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C4F3BAACC
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 19:34:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1F1E7CA0F3; Tue, 22 Oct 2019 19:34:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9763DA8E8;
        Tue, 22 Oct 2019 19:34:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 22 Oct 2019 19:34:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AABCC42EE38E;
        Tue, 22 Oct 2019 19:34:09 +0200 (CEST)
Date:   Tue, 22 Oct 2019 19:34:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nftables: secmark support
Message-ID: <20191022173411.zh3o2wnoqxpjhjkq@salvia>
References: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 22, 2019 at 05:57:25PM +0200, Christian Göttsche wrote:
> Hi,
> I am trying to finally get secmark with nftables to work.
> The kernel[1][2] and libnftnl[3] parts are done.
> For the nft front-end I think some things need a further change than
> already introduced[4].
> 
> 1.
> I found no way to store the secmark label into the connection tracking
> state and thereby set the label on established,related packets.
> Using a patch[5] it works with the following syntax:
> (Note: The patch will currently probably not apply to current master,
> due to [6])
> 
>     [... define secmarks and port maps ...]
>     chain input {
>         type filter hook input priority 0;
>         ct state new meta secmark set tcp dport map @secmapping_in
>         ct state new ip protocol icmp meta secmark set "icmp_server"
>         ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_server"
>         ct state new ct secmark_raw set meta secmark_raw
>         ct state established,related meta secmark_raw set ct secmark_raw

So your concern is the need for this extra secmark_raw, correct?

This is what your patch [6] does, right? If you don't mind to rebase
it I can have a look if I can propose you something else than this new
keyword.

>     }
>     chain output {
>         type filter hook output priority 0;
>         ct state new meta secmark set tcp dport map @secmapping_out
>         ct state new ip protocol icmp meta secmark set "icmp_client"
>         ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_client"
>         ct state new ct secmark_raw set meta secmark_raw
>         ct state established,related meta secmark_raw set ct secmark_raw
>     }
> 
> 2.
> The rules in 1. are not idempotent. The output of 'nft list ruleset' is:
> 
>     chain input {
>         type filter hook input priority filter; policy accept;
>         ct state new secmark name tcp dport map @secmapping_in
>         ct state new ip protocol icmp secmark name "icmp_server"
>         ct state new ip6 nexthdr ipv6-icmp secmark name "icmp_server"
>         ct state new ct secmark set secmark
>         ct state established,related secmark set ct secmark

This is the listing after you add ruleset in 1., correct?

>     }
>     chain output {
>         type filter hook output priority filter; policy accept;
>         ct state new secmark name tcp dport map @secmapping_out
>         ct state new ip protocol icmp secmark name "icmp_client"
>         ct state new ip6 nexthdr ipv6-icmp secmark name "icmp_client"
>         ct state new ct secmark set secmark
>         ct state established,related secmark set ct secmark
>     }
> 
> What are the code locations to fix?
> 
> 3.
> The patch also adds the ability to reset secmarks.
> Is there a way to query the kernel about the actual secid (to verify
> the reset works)?

What do you mean by "reset secmarks", example please.

> 4.
> Maybe I can contribute a howto for wiki.nftables.org. What is the
> preferred format?

That would be great indeed.

Sorry for the many questions!

[...]
> [1] https://github.com/torvalds/linux/commit/fb961945457f5177072c968aa38fee910ab893b9
> [2] https://github.com/torvalds/linux/commit/b473a1f5ddee5f73392c387940f4fbcbabfc3431
> [3] https://git.netfilter.org/libnftnl/commit/?id=aaf20ad0dc22d2ebcad1b2c43288e984f0efe2c3
> [4] https://git.netfilter.org/nftables/commit/?id=3bc84e5c1fdd1ff011af9788fe174e0514c2c9ea
> [5] https://salsa.debian.org/cgzones-guest/pkg-nftables/blob/master/debian/patches/0004-secmark-add-missing-pieces.patch
> [6] https://git.netfilter.org/nftables/commit/?id=998142c71d095d79488495ea545a704213fa0ba0
