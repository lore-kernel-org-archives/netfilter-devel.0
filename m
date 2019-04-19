Return-Path: <SRS0=LTAJ=SV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E3CC282DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C9F320645
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="ELUOSp8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfDSSwY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:52:24 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:46859 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfDSSwY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:52:24 -0400
Received: by mail-qt1-f170.google.com with SMTP id z17so6291095qts.13
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Apr 2019 11:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mLNXl5C5G9AuiWp4+HQP8sQ3DCF94vjXrZNNb+Dfan8=;
        b=ELUOSp8hDrVIbytxCUAwIPUOpjofwUqx8RricSdgF0MJl/+sf3zUjssgT5IZoSdNrh
         X1G5O60UOJe+aRdfWo69d1JzkmiafDOdepDcmuD8+099bA4LSqRo+nnAh24JzRNL2n7t
         B7Fk6jjsUwi7eedAsaPpgMztmU48XLUZhnks4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mLNXl5C5G9AuiWp4+HQP8sQ3DCF94vjXrZNNb+Dfan8=;
        b=CEZSYOY+ZihFK+9B1H3iEpUo0l78QM5q7DEWi6q+qgPYTmfVBfsONHtO36dDaKVbi2
         XyD2OXj93DMojIQjTCsXPo+oMjZhcE98ctE0BwvsAGO44f4b0nBqJVVWCCOIg0ZZMfxV
         WOsuxOvoasjtk7n3V0u3Z7HK0sTIGp2fCgE4Is8l7LhG5MQyF4aFVHkDb+J86Ii0JCLq
         fGXrA/tSp1FNMoWZg1k0iUXlDy8dYneW4K8CtMelcBADUCiF5PuwjDw5OsQiMTTVm/7x
         CjzpyTqvM6oeNYpePBOLCRWdCC11IoJ/N3wOj3ToqiSIxsthrGoj+lWxyV8QI3YBDB1q
         +41w==
X-Gm-Message-State: APjAAAXqXwG1If96JlecWFTf9krcqzRxNKEPG40CI1XpmDud4mNmGA2s
        VlTde0BPk3YYWaEuoEXfxyPFkep2xkYucw==
X-Google-Smtp-Source: APXvYqysuklCcAc9hbzDjag4CCT6CihEAY/QK/Rzt55eBFLSEJ0KKKs71HYxVHt1/qRlg25IIJk2Ig==
X-Received: by 2002:ac8:1008:: with SMTP id z8mr3749568qti.240.1555685768746;
        Fri, 19 Apr 2019 07:56:08 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id k89sm2697182qte.33.2019.04.19.07.56.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 07:56:08 -0700 (PDT)
Date:   Fri, 19 Apr 2019 10:56:05 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
Message-ID: <20190419145605.GA2592@pinebook>
References: <20190328195857.GA24011@pinebook>
 <20190411192248.7harez523hlkhh3e@breakpoint.cc>
 <20190412141834.GA25271@pinebook>
 <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc>
 <20190417144140.GA2866@pinebook>
 <alpine.DEB.2.20.1904181400270.23908@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1904181400270.23908@blackhole.kfki.hu>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 18-04-19, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Wed, 17 Apr 2019, Brett Mastbergen wrote:
> 
> > On 16-04-19, Florian Westphal wrote:
> > > Brett Mastbergen <bmastbergen@untangle.com> wrote:
> > > > This patch looks great.  That would greatly improve the usefulness of keying
> > > > off of the conntrack id.  If it gets accepted I can send a kernel patch and
> > > > an nft patch to support the ct id key.
> > > 
> > > That would be really nice to have.
> > > 
> > > > > > For a more in depth description of how things work I suggest reading the doc 
> > > > > > in the first link I posted, but below are a few simple examples of what is 
> > > > > > possible using dict expressions:
> > > > > > 
> > > > > > nft add rule ip filter forward dict sessions ct id application long_string 
> > > > > > NETFLIX reject 
> > > > > > 
> > > > > > If I were to describe that rule in plain English it would be:
> > > > > > 
> > > > > > For traffic passing through the ip filter table forward hook, use the 
> > > > > > conntrack id as a key to lookup an entry in the sessions table.  For that
> > > > > > entry check if it has an application field set to a string value of NETFLIX,
> > > > > > if so, reject the traffic.
> > > > > > 
> > > > > > How did that field get set to NETFLIX?  That is up to some other entity.  In 
> > > > > 
> > > > > Why isn't it possible to use the existing nftables set infrastructure
> > > > > for this?
> > > > > 
> > > > > The nft sets store arbitrary octets/bytes as keys, so we could at least
> > > > > from kernel side store arbitrary identifiers (strings, integers etc).
> > > > > 
> > > > 
> > > > I wanted to use the existing set infrastructure, but I ran into two issues
> > > > wrt to what we were trying to acheive:
> > > > 
> > > > 1.  As far as I can tell the current sets are only set up to hold elements
> > > > of a particular data type, where as we are storing elements of many different
> > > > types in a particular dictionary.
> > > 
> > > Yes, a set is only one data type (They support combining types though).
> > > 
> > > > 2.  sets are associated with a particular table and therefore can only be
> > > > accessed by rules in that table.  If you want to associate some piece of
> > > > information with a particular connection and use it from rules in multiple
> > > > different tables, you'd have to populate it in a set in each of those tables.
> > > 
> > > Yes, but thats intentional, a table forms a namespace; so
> > > crossing it is not desireable.
> > > 
> > > The idea is that different entities each can manage their own tables
> > > without clashing with chain or set names of another table.
> > > 
> > > Still looking at dicts code, I am trying to understand where normal nft
> > > set infra can't be used (or is too cumbersome) to best understand how we
> > > can fit dicts ideas into nftables' architecture.
> > 
> > The idea of some entity managing a table and its sets,rules,maps,etc in 
> > its own separate namespace makes total sense.  Thats one of the cool 
> > things about nftables.  I think what inspired us to create data stores 
> > that are more global, that can be accessed/updated from any table, is 
> > conntrack data.  If you think about things like the conntrack state, 
> > mark, bytes, status, etc, that is meta data about a connection that can 
> > be accessed from any table as long as the conntrack has been created.  
> > What we call the sessions table is really just more meta data about the 
> > connection that is keyed off of the conntrack id that can be 
> > accessed/updated from any table.  In our system we have a single entity 
> > that is responsible for populating sessions data, which then allows the 
> > entities managing tables to use it, or not.  Just the same way any table 
> > may or may not use conntrack data.
> 
> Yes, it's a valid argument. And you presented the two most natural 
> examples: data connected to conntrack entries and quotas (maintained in 
> the "filter" table and when the subject is over its quota, drop as early 
> as possible, in the "raw" table).
>  
> > As Dirk and I were discussing this yesterday we thought that maybe a 
> > "global" map would be close to what we are doing.  Something like below:
> 
> I think a "global" namespace could be the solution: sets and maps defined 
> in it could be used from any table (i.e. namespace). That is the contents 
> can be matched/updated/added/deleted from anywhere, but such sets/maps can 
> be defined/destroyed in "global" only.
> 
> nftables dictionaries are tightly coupled with their namespace because of 
> the verdict/jump part, so those would not be allowed in this global 
> namespace.
> 
> What do you think, is that a good generalization and could properly cover 
> your cases?
> 

Yes, I think your description of a global namespace that sets and maps can
be defined in sounds right on and would cover our use cases as far as where
the data resides (globally) and where it is accessible from (any table).

There are a couple other considerations I'd like to throw out there:

1.  Today it seems that nftables assumes that the map expressions will only
be used as the right hand expression of things like dnat and snat rules.

# from the wiki
nft add rule ip nat postrouting snat tcp dport map @porttoip

But we'd really like to be able to use map lookups on the left side of
comparisons so we can look up the additional meta data we put in a global
map and make some decision based on whether it matches:

nft add rule inet foo bar ct id map @application_map "netflix" drop

I've just about got that working locally.  It seems there isn't any
architectural reason that isn't possible today, I think it was just coded
up with the assumption of being a right side expression all the time.

2.  If you take a peek at our nft_dict documentation you'll notice we have
defined some new generic data types: int_type, int64_type, long_string, and
bool (I think upstream has a boolean type now though).  Since we are storing
lots of artibrary meta data in our tables we didn't want to have to define
a new data type every time we decided to store some new piece of data in a
table.  So instead of defining a new fixed length string subtype for
application type, we'd just define it as a long_string.  And instead of
defining a new fixed length integer subtype for reputation, we'd just
define it as an int_type.  Obviously, there are times when you do want
to define a new type if only certain values are valid, but we've found the
flexibility of these generic types to be really handy.
> > Create a global map from conntrack id to an application string (obviously
> > these data types and syntax are made up)
> > 
> > nft add map global application_map { type ct_id: app_string ; }
> > 
> > and then some table could have a rule like this:
> > 
> > nft add rule inet foo bar ct id map @application_map "netflix" drop
> > 
> > And then something a bit more complex: map connections to users and users
> > to quota status:
> > 
> > nft add map global user_map { type ct_id: username ; }
> > nft add map global over_quota { type username: bool ; }
> > nft add rule inet foo bar ct id map @user_map map @over_quota true drop
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
