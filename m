Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B91C282DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FD9620645
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="i5xOr/sT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbfDQOlq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:41:46 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:44398 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731844AbfDQOlp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:41:45 -0400
Received: by mail-qk1-f169.google.com with SMTP id y5so14461374qkc.11
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 07:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r0BSc5aeutf+diBXt1i4D8XJiR4j2ICwpTbsZfhKFwA=;
        b=i5xOr/sTQ1j2zFrbwzjiqLtmgaLIyGZTlfS3r3dtkwnYaeVv4IVhlY2IejpOTHrrTI
         8Vbzosvzr2czkQM/QyI4uI5i1ki1C5QsW++F5O4bJAJ0rXDoaume7LeDNpvQTa1je2yR
         p1/d16hP/U3KO/eDOSPfj5GJO1JByM/nw/vfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r0BSc5aeutf+diBXt1i4D8XJiR4j2ICwpTbsZfhKFwA=;
        b=j/wl9rsSAftF96+oIbMOBJZQxdLod4H/JMaTfC8uMCS5p+FsOEGQeJoq//ewiorGxn
         rMWfOgE3OC8xM1NxJVd8PxORk/wHSs+H29KyHZVayRQf6AD9w4G+eTneEWlaGgZbJdfk
         Qsd+Y4OOMTx4AttQVJMgLAY371nVB0WXf2AE2ucLFPS5Ndy8DWiIcfwTJV/LZogxBYR+
         StaK+ciuBbpI1RtEGfjAixsD9EMTTveNgvHIrNm7jWxHP9HSXk6Yy84DCRLJLotsYeW9
         /VHCl16sUE3nIO3ZAJJHGRkYUgjxkZWna6Pxc0gyHp6o/ctFV7a5PrRzwzwPc5OwBb2m
         2/vQ==
X-Gm-Message-State: APjAAAUBz7wRJS45M4093AG/ka8aYyM/1IOwJry/pO8AUp4rzqwNONTY
        SeH/a+g9eoEv7PZFUvjEIPmdwv/+Xus=
X-Google-Smtp-Source: APXvYqxbSD7kFlDKLx9XzPCkVTu1t4yglOkxQaH0mrMq1Axv2nP2X7d2XaNE8OrMdV8F2NDJFM49JA==
X-Received: by 2002:a37:4896:: with SMTP id v144mr67081325qka.194.1555512104315;
        Wed, 17 Apr 2019 07:41:44 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id f47sm43218902qta.80.2019.04.17.07.41.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 07:41:43 -0700 (PDT)
Date:   Wed, 17 Apr 2019 10:41:40 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
Message-ID: <20190417144140.GA2866@pinebook>
References: <20190328195857.GA24011@pinebook>
 <20190411192248.7harez523hlkhh3e@breakpoint.cc>
 <20190412141834.GA25271@pinebook>
 <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 16-04-19, Florian Westphal wrote:
> Brett Mastbergen <bmastbergen@untangle.com> wrote:
> > This patch looks great.  That would greatly improve the usefulness of keying
> > off of the conntrack id.  If it gets accepted I can send a kernel patch and
> > an nft patch to support the ct id key.
> 
> That would be really nice to have.
> 
> > > > For a more in depth description of how things work I suggest reading the doc 
> > > > in the first link I posted, but below are a few simple examples of what is 
> > > > possible using dict expressions:
> > > > 
> > > > nft add rule ip filter forward dict sessions ct id application long_string 
> > > > NETFLIX reject 
> > > > 
> > > > If I were to describe that rule in plain English it would be:
> > > > 
> > > > For traffic passing through the ip filter table forward hook, use the 
> > > > conntrack id as a key to lookup an entry in the sessions table.  For that
> > > > entry check if it has an application field set to a string value of NETFLIX,
> > > > if so, reject the traffic.
> > > > 
> > > > How did that field get set to NETFLIX?  That is up to some other entity.  In 
> > > 
> > > Why isn't it possible to use the existing nftables set infrastructure
> > > for this?
> > > 
> > > The nft sets store arbitrary octets/bytes as keys, so we could at least
> > > from kernel side store arbitrary identifiers (strings, integers etc).
> > > 
> > 
> > I wanted to use the existing set infrastructure, but I ran into two issues
> > wrt to what we were trying to acheive:
> > 
> > 1.  As far as I can tell the current sets are only set up to hold elements
> > of a particular data type, where as we are storing elements of many different
> > types in a particular dictionary.
> 
> Yes, a set is only one data type (They support combining types though).
> 
> > 2.  sets are associated with a particular table and therefore can only be
> > accessed by rules in that table.  If you want to associate some piece of
> > information with a particular connection and use it from rules in multiple
> > different tables, you'd have to populate it in a set in each of those tables.
> 
> Yes, but thats intentional, a table forms a namespace; so
> crossing it is not desireable.
> 
> The idea is that different entities each can manage their own tables
> without clashing with chain or set names of another table.
> 
> Still looking at dicts code, I am trying to understand where normal nft
> set infra can't be used (or is too cumbersome) to best understand how we
> can fit dicts ideas into nftables' architecture.

The idea of some entity managing a table and its sets,rules,maps,etc in its
own separate namespace makes total sense.  Thats one of the cool things about
nftables.  I think what inspired us to create data stores that are more
global, that can be accessed/updated from any table, is conntrack data.  If
you think about things like the conntrack state, mark, bytes, status, etc,
that is meta data about a connection that can be accessed from any table as
long as the conntrack has been created.  What we call the sessions table is
really just more meta data about the connection that is keyed off of the
conntrack id that can be accessed/updated from any table.  In our system we
have a single entity that is responsible for populating sessions data, which
then allows the entities managing tables to use it, or not.  Just the same
way any table may or may not use conntrack data.

As Dirk and I were discussing this yesterday we thought that maybe a
"global" map would be close to what we are doing.  Something like below:

Create a global map from conntrack id to an application string (obviously
these data types and syntax are made up)

nft add map global application_map { type ct_id: app_string ; }

and then some table could have a rule like this:

nft add rule inet foo bar ct id map @application_map "netflix" drop

And then something a bit more complex: map connections to users and users
to quota status:

nft add map global user_map { type ct_id: username ; }
nft add map global over_quota { type username: bool ; }
nft add rule inet foo bar ct id map @user_map map @over_quota true drop
