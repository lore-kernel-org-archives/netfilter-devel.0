Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD02EC38BE0
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 19:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BB020656
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 19:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VnAeAS+F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgBXTr4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:47:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726687AbgBXTr4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 14:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582573674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nnxs4S3V4j1u81O81rJrhpwntUjBUuBdMvRvoYKsH34=;
        b=VnAeAS+FgR/N+SBfwvt4oTSWCXZjDasbEqJ79VIAGXCiyhL/5gP6T+KIYRgmQo7oRPd3E5
        U0WQKc1N2RiEJTJYOkDNwCsSN81AN79EuCnQBorUlar5WnF5s7QvD75jBLGawChc7g886P
        +Kc5TQ7kJ0CdFu+YEUQIXsKKGznvYpg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-9oF_FChzO4KL4VkzxALH6w-1; Mon, 24 Feb 2020 14:47:50 -0500
X-MC-Unique: 9oF_FChzO4KL4VkzxALH6w-1
Received: by mail-ed1-f71.google.com with SMTP id c24so7415653edy.9
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 11:47:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nnxs4S3V4j1u81O81rJrhpwntUjBUuBdMvRvoYKsH34=;
        b=jQ9aoSvp+u7FimAbi1w44RizCENHeBcMYcpjlyhgq2tP1HpkHqtts2YDV8KpVg+zQ9
         AXp+4ZBE6Qay1MHNIFiUhX8wLpHyi3y+KGbXDGwbwZz9f0pt1JVGsEP6cgJDBjLft7ya
         XLO+wE6daCefkfStFN4EdC86BzVD/ZTPZ5c4oY5p3RQzKuTDUj1m0cOG8fIGch+gJUaX
         azpXwlJvSEAmxEtHKWT1KsWf842n01WAjrGdccx+BrW8tWdxCqM54JEkTUbUPzjUY8Hq
         QX+thCxwZ8VZk8sFvVtOIiZNr7Hyq6gkdQj/dGAaIxA8cnK+1SP5tWYPoWHfr9gFftp8
         Z7+Q==
X-Gm-Message-State: APjAAAXaYD0zPDKQHzR2uuPiHyYASBfLH0QUyc9xdjziVfMCf0VKH01t
        DuCsFOcXn60WuVOIC0PDqU/B6+GNQboy/BKYzIV4n7Z+va+cFVh2T/Yj1eS7DmEqR/FcD6IRW4l
        8BhNJavdAOjiwoVzLRhMLXdeo2iuYM6sDw37+7hFvLz9y
X-Received: by 2002:a17:906:ce57:: with SMTP id se23mr48387486ejb.362.1582573669106;
        Mon, 24 Feb 2020 11:47:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqytTPwGRqhKju/NQPHj9LOagQ32SFVcrzvfbIgfGBW57jVwx7rncRDFd0C3JXVggWYL8tobRTZVXYqtNRKtLfc=
X-Received: by 2002:a17:906:ce57:: with SMTP id se23mr48387474ejb.362.1582573668885;
 Mon, 24 Feb 2020 11:47:48 -0800 (PST)
MIME-Version: 1.0
References: <20200224185529.50530-1-mcroce@redhat.com> <20200224191154.GH19559@breakpoint.cc>
 <CAGnkfhyUOyd1XWdSSxL844RG-_z32qGasV7a+2m7XNrS8qvtCw@mail.gmail.com>
In-Reply-To: <CAGnkfhyUOyd1XWdSSxL844RG-_z32qGasV7a+2m7XNrS8qvtCw@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 24 Feb 2020 20:47:13 +0100
Message-ID: <CAGnkfhzA6j2B43DFgQedeGE6H5XvHKWd7KPg3ocGVr0K_u2NJA@mail.gmail.com>
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

On Mon, Feb 24, 2020 at 8:42 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Mon, Feb 24, 2020 at 8:12 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Matteo Croce <mcroce@redhat.com> wrote:
> > > As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
> > > and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
> > > __ip_options_compile() must be called under rcu protection.
> >
> > This is not needed, all netfilter hooks run with rcu_read_lock held.
> >
>
> Ok, so let's drop it, thanks.

What about adding a RCU_LOCKDEP_WARN() in __ip_options_compile() to
protect against future errors? Something like:

----------------------------------%<-------------------------------------
@@ -262,6 +262,9 @@ int __ip_options_compile(struct net *net,
  unsigned char *iph;
  int optlen, l;

+ RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+ __FUNC__ " needs rcu_read_lock() protection");
+
  if (skb) {
  rt = skb_rtable(skb);
  optptr = (unsigned char *)&(ip_hdr(skb)[1]);
---------------------------------->%-------------------------------------

Bye,
-- 
Matteo Croce
per aspera ad upstream

