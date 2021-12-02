Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06132C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 15:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358930AbhLBP2a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:28:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347566AbhLBP23 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 10:28:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638458706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hk53Fln12To9/u6sj2OfvZtKZIXAX1Y4E/TYbLKBo4I=;
        b=UZs32M1diuipaQ9QUF4GH2hJifVMG4TfNRZisKZubHFa/ybwV4hfdMHSNMhGZEIMAaCWPZ
        xc5My2RAjnnwTEaRxp1bN+muGvigzTC/ASWs9Bokg0RWsmclVs79uRP4PkIYeOlo8v1kSi
        uxSeOvaf1XobGjwRJygBt8rCyy+PVAc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-hpV3KV3mP9eRWFi9FXTncw-1; Thu, 02 Dec 2021 10:25:05 -0500
X-MC-Unique: hpV3KV3mP9eRWFi9FXTncw-1
Received: by mail-ed1-f71.google.com with SMTP id w5-20020a05640234c500b003f1b9ab06d2so11747704edc.13
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Dec 2021 07:25:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=Hk53Fln12To9/u6sj2OfvZtKZIXAX1Y4E/TYbLKBo4I=;
        b=5gVSVEnLdQHjmICgOcXt//1oxCA2paBHfA80n5KlYKv6t+nce3RodGZPZlGo4ig4yf
         nmYn1y+80qUSaYFWCe7SULE0JeZpCs7V/RPiEoKyq931ESsQa3owSjJMeIdIDgs+9mqd
         fr1xp122ChFK9LwEtVVpwHkuoDYrHT8UBpQ+HGoepAoo8LRK8rfkWM2qiwMc2Jxu8/g+
         VhiKK6P2QHg43RoKT+CSEQG/+rSRdc/ZNsUz63eEypzJnmAov0VkEYJmAGZvU3QNtrxh
         kQ23ayF4dy6vFZkAOIF47RkqXlgKbWpWFgieemLY3NUIVAXc6Ezs+Uej8p/6MOs1nXps
         Ys5w==
X-Gm-Message-State: AOAM531zww7WsmAsI08Nlhfz7H2NzjuhEc1cqvo0+XZ5NtI95rG/0fLa
        R0sDBnklmVKe/PH2rnR84y/tqmJj1ru3A5loFyLPr1SkJKblq6kaii7KDcA/ixAV7B3BFBxyzzQ
        amRoA2b744eZUar42qLPYv/dzSWuR
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr19060644edc.44.1638458704400;
        Thu, 02 Dec 2021 07:25:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLFWpvNWDZgm/ACIQBMgT7YsV/GDLHgMnE5HFR676tDcSuky5iySO03URHH60d5QPaX2k0Wg==
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr19060617edc.44.1638458704217;
        Thu, 02 Dec 2021 07:25:04 -0800 (PST)
Received: from localhost ([185.112.167.59])
        by smtp.gmail.com with ESMTPSA id v10sm37561edt.24.2021.12.02.07.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 07:25:03 -0800 (PST)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>, phil@nwl.cc
Subject: Re: [PATCH nft] tests: shell: better parameters for the interval
 stack overflow test
In-Reply-To: <20211201112614.GB2315@breakpoint.cc>
References: <20211201111200.424375-1-snemec@redhat.com>
 <20211201112614.GB2315@breakpoint.cc>
User-Agent: Notmuch/0.34.1 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Thu, 02 Dec 2021 16:26:00 +0100
Message-ID: <20211202162600+0100.565956-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 01 Dec 2021 12:26:14 +0100
Florian Westphal wrote:

> =C5=A0t=C4=9Bp=C3=A1n N=C4=9Bmec <snemec@redhat.com> wrote:
>> Wider testing has shown that 128 kB stack is too low (e.g. for systems
>> with 64 kB page size), leading to false failures in some environments.
>
> We could try to get rid of large on-stack allocations and always malloc
> instead.

[I think this might rather be a topic for discussion with other
developers and maintainers, but given that I was alone in the To:
header, here's my 0.02 CZK, to not leave this hanging:]

My patch only addresses the regression test for one case where stack
allocation lead to runaway stack. Looking for and fixing other such code
paths (if any) does sound like a good idea to me.

If you meant an effort to decrease nftables stack usage in general, I
think I have neither the experience nor the expertise to provide an
informed opinion on that.

On a superficial look, nft stack size doesn't seem small, but not
outrageous, either (the below is with nftables-0.9.8-9.el9.x86_64
(RHEL), but I get about the same numbers on Arch with the 1.0.1 release;
both nftables and iptables rule sets were empty, but for nftables stack
usage that doesn't seem to make any difference; for iptables-save it
does: 51248 B with a nonempty rule set):

# memusage nft list ruleset 2>&1 | grep -o 'stack peak: .*'
stack peak: 98400

Same thing with
iptables-save:       38352
bash -c exit:         5456
python -Sc 'exit()': 23360
python -Sm os:       70448=20
vim -c q:           105872

  Thanks,

  =C5=A0t=C4=9Bp=C3=A1n

