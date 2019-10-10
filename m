Return-Path: <SRS0=6wcg=YD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E2BC4360C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F246220B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfJJWtj convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:49:39 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:50656 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbfJJWtj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 18:49:39 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2019 18:49:39 EDT
Received: from dispatchb-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatchb-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 854191CBEC1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2019 22:41:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 63FE61C0065;
        Thu, 10 Oct 2019 22:41:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 10 Oct
 2019 15:41:39 -0700
Subject: Re: [PATCH v2 nf-next] netfilter: add and use nf_hook_slow_list()
To:     Florian Westphal <fw@strlen.de>, <netfilter-devel@vger.kernel.org>
References: <20191010223037.10811-1-fw@strlen.de>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <2d9864c9-95d2-02c2-b256-85a07c2b2232@solarflare.com>
Date:   Thu, 10 Oct 2019 23:41:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191010223037.10811-1-fw@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24966.005
X-TM-AS-Result: No-3.259100-4.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/uHYS4ybQtcOsmB4bNJoA6M69aS+7/zbj+qvcIF1TcLYH+M
        cFcxiFqIrXMOxnDE+MS8NwpJFqkwjlTNH/IEdCNmuwdUMMznEA/qobkz1A0A7WtEzrC9eANpptN
        rryJ4UEgOg0w9ptBzQbZmrseZYNO5Scc3TMVaAvawWQIt565820yEf8qljHK7YtJaVJe/wLFbNg
        hvgGd2vH0tCKdnhB58ZYJ9vPJ1vSDefx4FmMaZTOTCMddcL/gjymsk/wUE4hrG7O+qZQ0TmeRk/
        OEm2E2GDtZ+Ne9qwRiIXsRWiZP3VVl5ADyKG1Sz4T4wKnftmEKY1HxpAJSTIJP2g7sNfpKtFgH7
        y2B35ISAszijdiV7qCmrallLEixoqiftjGsrnVLHLBltO4st2n5CgYvfL1UC
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.259100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24966.005
X-MDID: 1570747304-pW7CGdSvtS_U
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 10/10/2019 23:30, Florian Westphal wrote:
> NF_HOOK_LIST now only works for ipv4 and ipv6, as those are the only
> callers.
...
> +
> +     rcu_read_lock();
> +     switch (pf) {
> +     case NFPROTO_IPV4:
> +             hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
> +             break;
> +     case NFPROTO_IPV6:
> +             hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
> +             break;
> +     default:
> +             WARN_ON_ONCE(1);
> +             break;
>       }
Would it not make sense instead to abstract out the switch in nf_hook()
 into, say, an inline function that could be called from here?  That
 would satisfy SPOT and also save updating this code if new callers of
 NF_HOOK_LIST are added in the future.

(Sorry I didn't spot this the first time around; I don't know the NF
 code all that well.)

-Ed
The information contained in this message is confidential and is intended for the addressee(s) only. If you have received this message in error, please notify the sender immediately and delete the message. Unless you are an addressee (or authorized to receive for an addressee), you may not use, copy or disclose to anyone this message or any information contained in this message. The unauthorized use, disclosure, copying or alteration of this message is strictly prohibited.
