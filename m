Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98335C38BE2
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 19:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7148A20CC7
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 19:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TBqDzJhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXTnJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:43:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726664AbgBXTnJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 14:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582573388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UPEDBw2q2/zVnpRqbyDC0y/dD98/YWWp9w4/MyvOaPI=;
        b=TBqDzJhRGzKsQK/5pTqN6I9wWxKAhn5UrjRFMCkMthDCzfd+M+/L+c65SVNrobdlWlNi2l
        5h+xm9J2flI4/iCIYxSdolgLv8lJ5nLs9sZ+F26evNEB2UfNu0BrOitB5AO46JbOW6rU1Q
        kFQ9Wd6+jeBwUs5K/xVE7tEjwpkqXUU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-AuTEkmw7P8GUGQU7lBQbeg-1; Mon, 24 Feb 2020 14:43:06 -0500
X-MC-Unique: AuTEkmw7P8GUGQU7lBQbeg-1
Received: by mail-ed1-f70.google.com with SMTP id m21so7378687edp.14
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 11:43:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UPEDBw2q2/zVnpRqbyDC0y/dD98/YWWp9w4/MyvOaPI=;
        b=isRgtwUQMBid5eDlgL0Y+AcQ0LBb6zy/ngAinYmVqh3fDRELNbQCZ+PUO85O9Y7aHZ
         G5r4DmkhybAAog5P1eE9pcMQn/A+PbaI4+SP70qnsgGf8E0wclWfIwvY84ZoAId0GWox
         Rby3ifr2Nh9XR2G2QSoT7FNZKU+DJIVtxKwaRkHOnX3QWdPEl2R/ih/ryaa26PnNFoKo
         hF7gmkE9tCVgpDWp4SYXGc6u+igMIqkizy1BHSBvzJUvtt8N9T1c1ry5hFRSAdJ7Kjti
         R2S5cJQ/eNAhaaiP9Eb0ECBoKCNVzFEPJ2vU7JL/2y+S4FTeP8Xa59a/1qCuQp+YH38t
         EVqw==
X-Gm-Message-State: APjAAAXjpLP9sEf6PQPkx/OJQLTemsSTOkVnZPiMdRdcQ/IJM58oxJIx
        KSjbAYOkEUa10ssnLZrHP4lB8QY5+r7SgrWfnz99fNQCceFQ7CELsmDw2hdot2E5deFGf+5fT+L
        mabSc2ntp3FvxZlq/ERidWt5iIiHfH33DABuyl9Gt9Atg
X-Received: by 2002:aa7:c707:: with SMTP id i7mr47033917edq.287.1582573385342;
        Mon, 24 Feb 2020 11:43:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7hGQH+EDqFTrWey8Z79uUeupBz1Q0g4hvPLJr6VyJj0z08Kj/PZCQBR3230yo3IpOEuhkhq5q2+dh4qw2gN8=
X-Received: by 2002:aa7:c707:: with SMTP id i7mr47033902edq.287.1582573385142;
 Mon, 24 Feb 2020 11:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20200224185529.50530-1-mcroce@redhat.com> <20200224191154.GH19559@breakpoint.cc>
In-Reply-To: <20200224191154.GH19559@breakpoint.cc>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 24 Feb 2020 20:42:29 +0100
Message-ID: <CAGnkfhyUOyd1XWdSSxL844RG-_z32qGasV7a+2m7XNrS8qvtCw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ensure rcu_read_lock() in ipv4_find_option()
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 24, 2020 at 8:12 PM Florian Westphal <fw@strlen.de> wrote:
>
> Matteo Croce <mcroce@redhat.com> wrote:
> > As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
> > and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
> > __ip_options_compile() must be called under rcu protection.
>
> This is not needed, all netfilter hooks run with rcu_read_lock held.
>

Ok, so let's drop it, thanks.

-- 
Matteo Croce
per aspera ad upstream

