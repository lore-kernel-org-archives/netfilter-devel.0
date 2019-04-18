Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E86C10F0E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 12:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A2A9217D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 12:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="QIHyJ7k2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388939AbfDRMWi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:22:38 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:41667 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRMWi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 08:22:38 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2019 08:22:37 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8EAF2CC00DF;
        Thu, 18 Apr 2019 14:13:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1555589624; x=1557404025; bh=7qOqTG3avy
        mhcHrCtZ410CInYOMoTtXL/aSYLu7ZZok=; b=QIHyJ7k2Dbk35fLCpQWSnVneUL
        FbyRmtvWmIYdaY03mJ0T8XTFe7WbGuha4LGHOLXbpuvIZwpbItsCSIn7+/Zv66VR
        QOVt12OOg9VgEonGzXq6YdnhgV4shs2BsxXCUWjh6uwEjM1ECpmJzrjuBu/KM4/i
        GZ9OWwKcvCU0Y2J8M=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 18 Apr 2019 14:13:44 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 78529CC00BB;
        Thu, 18 Apr 2019 14:13:44 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 178F120AAE; Thu, 18 Apr 2019 14:13:44 +0200 (CEST)
Date:   Thu, 18 Apr 2019 14:13:43 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Brett Mastbergen <bmastbergen@untangle.com>
cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
In-Reply-To: <20190417144140.GA2866@pinebook>
Message-ID: <alpine.DEB.2.20.1904181400270.23908@blackhole.kfki.hu>
References: <20190328195857.GA24011@pinebook> <20190411192248.7harez523hlkhh3e@breakpoint.cc> <20190412141834.GA25271@pinebook> <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc> <20190417144140.GA2866@pinebook>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 17 Apr 2019, Brett Mastbergen wrote:

> On 16-04-19, Florian Westphal wrote:
> > Brett Mastbergen <bmastbergen@untangle.com> wrote:
> > > This patch looks great.  That would greatly improve the usefulness of keying
> > > off of the conntrack id.  If it gets accepted I can send a kernel patch and
> > > an nft patch to support the ct id key.
> > 
> > That would be really nice to have.
> > 
> > > > > For a more in depth description of how things work I suggest reading the doc 
> > > > > in the first link I posted, but below are a few simple examples of what is 
> > > > > possible using dict expressions:
> > > > > 
> > > > > nft add rule ip filter forward dict sessions ct id application long_string 
> > > > > NETFLIX reject 
> > > > > 
> > > > > If I were to describe that rule in plain English it would be:
> > > > > 
> > > > > For traffic passing through the ip filter table forward hook, use the 
> > > > > conntrack id as a key to lookup an entry in the sessions table.  For that
> > > > > entry check if it has an application field set to a string value of NETFLIX,
> > > > > if so, reject the traffic.
> > > > > 
> > > > > How did that field get set to NETFLIX?  That is up to some other entity.  In 
> > > > 
> > > > Why isn't it possible to use the existing nftables set infrastructure
> > > > for this?
> > > > 
> > > > The nft sets store arbitrary octets/bytes as keys, so we could at least
> > > > from kernel side store arbitrary identifiers (strings, integers etc).
> > > > 
> > > 
> > > I wanted to use the existing set infrastructure, but I ran into two issues
> > > wrt to what we were trying to acheive:
> > > 
> > > 1.  As far as I can tell the current sets are only set up to hold elements
> > > of a particular data type, where as we are storing elements of many different
> > > types in a particular dictionary.
> > 
> > Yes, a set is only one data type (They support combining types though).
> > 
> > > 2.  sets are associated with a particular table and therefore can only be
> > > accessed by rules in that table.  If you want to associate some piece of
> > > information with a particular connection and use it from rules in multiple
> > > different tables, you'd have to populate it in a set in each of those tables.
> > 
> > Yes, but thats intentional, a table forms a namespace; so
> > crossing it is not desireable.
> > 
> > The idea is that different entities each can manage their own tables
> > without clashing with chain or set names of another table.
> > 
> > Still looking at dicts code, I am trying to understand where normal nft
> > set infra can't be used (or is too cumbersome) to best understand how we
> > can fit dicts ideas into nftables' architecture.
> 
> The idea of some entity managing a table and its sets,rules,maps,etc in 
> its own separate namespace makes total sense.  Thats one of the cool 
> things about nftables.  I think what inspired us to create data stores 
> that are more global, that can be accessed/updated from any table, is 
> conntrack data.  If you think about things like the conntrack state, 
> mark, bytes, status, etc, that is meta data about a connection that can 
> be accessed from any table as long as the conntrack has been created.  
> What we call the sessions table is really just more meta data about the 
> connection that is keyed off of the conntrack id that can be 
> accessed/updated from any table.  In our system we have a single entity 
> that is responsible for populating sessions data, which then allows the 
> entities managing tables to use it, or not.  Just the same way any table 
> may or may not use conntrack data.

Yes, it's a valid argument. And you presented the two most natural 
examples: data connected to conntrack entries and quotas (maintained in 
the "filter" table and when the subject is over its quota, drop as early 
as possible, in the "raw" table).
 
> As Dirk and I were discussing this yesterday we thought that maybe a 
> "global" map would be close to what we are doing.  Something like below:

I think a "global" namespace could be the solution: sets and maps defined 
in it could be used from any table (i.e. namespace). That is the contents 
can be matched/updated/added/deleted from anywhere, but such sets/maps can 
be defined/destroyed in "global" only.

nftables dictionaries are tightly coupled with their namespace because of 
the verdict/jump part, so those would not be allowed in this global 
namespace.

What do you think, is that a good generalization and could properly cover 
your cases?

> Create a global map from conntrack id to an application string (obviously
> these data types and syntax are made up)
> 
> nft add map global application_map { type ct_id: app_string ; }
> 
> and then some table could have a rule like this:
> 
> nft add rule inet foo bar ct id map @application_map "netflix" drop
> 
> And then something a bit more complex: map connections to users and users
> to quota status:
> 
> nft add map global user_map { type ct_id: username ; }
> nft add map global over_quota { type username: bool ; }
> nft add rule inet foo bar ct id map @user_map map @over_quota true drop

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
