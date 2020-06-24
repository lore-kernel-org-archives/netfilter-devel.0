Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15047C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 00:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C1A2078E
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 00:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="Il6fK4QN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbgFXAfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 20:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388165AbgFXAfJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 20:35:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CC9C061755
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 17:35:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id cy7so173176edb.5
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 17:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+/TMyKbqoSzMGZ/AAiVOjNfJfvqMvVU1A+eHQRRA5RQ=;
        b=Il6fK4QN3tYHRegbTX3T3xxgdNRK5bhnoaFX2nMUJ+Y1ejGKz2mICnpBctazU0eFYI
         +6WYLhCDE5IutdeL6ipgrxuodVn0WCfWMCh+6ZjduvztoIRvdYwvs+tLmVdloyVBKiKd
         Xd+vTYw8xNdYoCfPjbV2eezQeBcRSM44RaXGj8NkQxehNrlsHYyXRmkwpyHmy1siSgO6
         ZFYlVPr2FiXxrnQJ36LJoAm40RFBS9bsdAG8NX38Q6o9LJ9GpiteFIUbzRViVzxjz2QG
         dtjlJa9eIfNen/2eoSRu75VwCM/b6Rv/nw0czAWfLNCBBqW2ylJSvPSws70uAz6eaETU
         GddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+/TMyKbqoSzMGZ/AAiVOjNfJfvqMvVU1A+eHQRRA5RQ=;
        b=dy/qFGhq5f7F2tdE3tOHEq0e+BIdni3GMyOcygpBeeG9O+LnKBMGbwe1sZ2g61splq
         AbQQdQ6XYQzYs65vzyt9uh/1b6iB7NH+f3ru9l6og2AnDkECWjy1CXpQhpHtn4vFUtol
         5Y6tqoTb7tqKX0/YgkHqzqxKDls7XijBRTUhnbtCS32VDOrWyGdt9SXJfzyefZbykTnf
         Z+QLA+KV5bZ4JOQceY109KYCa1xZa8MeXzOlei20RdCa6brnpOCcTGcm5bh3B8ry80JY
         CaV7hWFd6MWT6Q8WliX4wuQR21A/1223p7jePjT5TpP7Du1rjKjmIbfaRtOGT/gzw0c+
         vn4A==
X-Gm-Message-State: AOAM533noX+c6lMMB3WMYMPovc1zfh3uDnR4O5D1l5lhFdNAAzvFm9pS
        PrHngdQWgu/rXbADUH68CLJal5JpFxLxI8Zi/i/Q
X-Google-Smtp-Source: ABdhPJzCoP7TVvW+uzKj9SzidO2EBCvvtbfilZfpp8veq16/F/lTMvRYgUtkcV+HaRYoxjS+CxUYyH2LxC0Ele3/EA8=
X-Received: by 2002:aa7:da46:: with SMTP id w6mr23979297eds.31.1592958906753;
 Tue, 23 Jun 2020 17:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
In-Reply-To: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 23 Jun 2020 20:34:55 -0400
Message-ID: <CAHC9VhT_dzkoOuoQF5-D9KFDiAUUjX2UJJbKPWAeXkf7fddKsA@mail.gmail.com>
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change events
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 4, 2020 at 9:21 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> iptables, ip6tables, arptables and ebtables table registration,
> replacement and unregistration configuration events are logged for the
> native (legacy) iptables setsockopt api, but not for the
> nftables netlink api which is used by the nft-variant of iptables in
> addition to nftables itself.
>
> Add calls to log the configuration actions in the nftables netlink api.
>
> This uses the same NETFILTER_CFG record format but overloads the table
> field.
>
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=?:0;?:0 family=unspecified entries=2 op=nft_register_gen pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=firewalld:1;?:0 family=inet entries=0 op=nft_register_table pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=8 op=nft_register_chain pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=101 op=nft_register_rule pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=87 op=nft_register_setelem pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=0 op=nft_register_set pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>
> For further information please see issue
> https://github.com/linux-audit/audit-kernel/issues/124
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
> Changelog:
> v3:
> - inline message type rather than table
>
> v2:
> - differentiate between xtables and nftables
> - add set, setelem, obj, flowtable, gen
> - use nentries field as appropriate per type
> - overload the "tables" field with table handle and chain/set/flowtable
>
>  include/linux/audit.h         |  18 ++++++++
>  kernel/auditsc.c              |  24 ++++++++--
>  net/netfilter/nf_tables_api.c | 103 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 142 insertions(+), 3 deletions(-)

I'm not seeing any additional comments from the netfilter folks so
I've gone ahead and merged this into audit/next.  Thanks Richard.

-- 
paul moore
www.paul-moore.com
