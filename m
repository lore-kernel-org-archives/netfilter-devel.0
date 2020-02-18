Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C89C3404B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 21:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA762176D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 21:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgBRVGR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 16:06:17 -0500
Received: from correo.us.es ([193.147.175.20]:37788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgBRVGR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 16:06:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8423A27F8AE
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 22:06:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7033DDA3C3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 22:06:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6562EDA801; Tue, 18 Feb 2020 22:06:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 400ACDA39F;
        Tue, 18 Feb 2020 22:06:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 22:06:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2037542EE38E;
        Tue, 18 Feb 2020 22:06:12 +0100 (CET)
Date:   Tue, 18 Feb 2020 22:06:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] src: Fix nftnl_assert() on data_len
Message-ID: <20200218210611.4woiwhndyc35rzoz@salvia>
References: <20200214172417.11217-1-phil@nwl.cc>
 <20200214173247.2wbrvcqilqfmcqq5@salvia>
 <20200214173450.GR20005@orbyte.nwl.cc>
 <20200214174200.4xrvnlb72qebtvnb@salvia>
 <20200215004311.GS20005@orbyte.nwl.cc>
 <20200215131713.5gwn4ayk2udjff33@salvia>
 <20200215225855.GU20005@orbyte.nwl.cc>
 <20200218134227.yndixbtxjzq3jznk@salvia>
 <20200218181851.GC20005@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bzwnr6mtl6uux44f"
Content-Disposition: inline
In-Reply-To: <20200218181851.GC20005@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--bzwnr6mtl6uux44f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2020 at 07:18:51PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Feb 18, 2020 at 02:42:27PM +0100, Pablo Neira Ayuso wrote:
> > On Sat, Feb 15, 2020 at 11:58:55PM +0100, Phil Sutter wrote:
> > > On Sat, Feb 15, 2020 at 02:17:13PM +0100, Pablo Neira Ayuso wrote:
> > > > On Sat, Feb 15, 2020 at 01:43:11AM +0100, Phil Sutter wrote:
> > > > > On Fri, Feb 14, 2020 at 06:42:00PM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Fri, Feb 14, 2020 at 06:34:50PM +0100, Phil Sutter wrote:
> > > > > > > On Fri, Feb 14, 2020 at 06:32:47PM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > On Fri, Feb 14, 2020 at 06:24:17PM +0100, Phil Sutter wrote:
> > > > > > > > > Typical idiom for *_get_u*() getters is to call *_get_data() and make
> > > > > > > > > sure data_len matches what each of them is returning. Yet they shouldn't
> > > > > > > > > trust *_get_data() to write into passed pointer to data_len since for
> > > > > > > > > chains and NFTNL_CHAIN_DEVICES attribute, it does not. Make sure these
> > > > > > > > > assert() calls trigger in those cases.
> > > > > > > > 
> > > > > > > > The intention to catch for unset attributes through the assertion,
> > > > > > > > right?
> > > > > > > 
> > > > > > > No, this is about making sure that no wrong getter is called, e.g.
> > > > > > > nftnl_chain_get_u64() with e.g. NFTNL_CHAIN_HOOKNUM attribute which is
> > > > > > > only 32bits.
> > > > > > 
> > > > > > I think it will also catch the case I'm asking. If attribute is unset,
> > > > > > then nftnl_chain_get_data() returns NULL and the assertion checks
> > > > > > data_len, which has not been properly initialized.
> > > > > 
> > > > > With nftnl_assert() being (shortened):
> > > > > 
> > > > > | #define nftnl_assert(val, attr, expr) \
> > > > > |  ((!val || expr) ? \
> > > > > |  (void)0 : __nftnl_assert_fail(attr, __FILE__, __LINE__))
> > > > > 
> > > > > Check for 'expr' (which is passed as 'data_len == sizeof(<something>)')
> > > > > will only happen if 'val' is not NULL. Callers then return like so:
> > > > > 
> > > > > | return val ? *val : 0;
> > > > > 
> > > > > This means that if you pass an unset attribute to the getter, it will
> > > > > simply return 0.
> > > > 
> > > > Thanks for explaining, Phil. If the problem is just
> > > > NFTNL_CHAIN_DEVICES and NFTNL_FLOWTABLE_DEVICES, probably this is just
> > > > fine? So zero data-length is reversed for arrays and update
> > > > nftnl_assert() to skip data_len == 0, ie.
> > > > 
> > > > > | #define nftnl_assert(val, attr, expr) \
> > > > > |  ((!val || data_len == 0 || expr) ? \
> > > > > |  (void)0 : __nftnl_assert_fail(attr, __FILE__, __LINE__))
> > > 
> > > Your proposed patch would allow to call e.g.:
> > > 
> > > | nftnl_chain_get_u32(c, NFTNL_CHAIN_DEVICES)
> > > 
> > > This would return (uint32_t)*(&c->dev_array[0]), I highly doubt we
> > > should allow this. Unless I miss something, it is certainly a
> > > programming error if someone calls any of the nftnl_chain_get_{u,s}*
> > > getters on NFTNL_CHAIN_DEVICES attribute. So aborting with error message
> > > in nftnl_assert() is not only OK but actually helpful, no?
> > 
> > Indeed, good point.
> > 
> > I don't think nftnl_flowtable_set_data() is good for these two device
> > array.
> 
> Well, right now it serves as a backend for all attribute setters, and
> your patch continues in that tradition. So while it may be a bit
> "rustic", I'd say it's good enough for its purpose. :)
> 
> > I just sent a patch, I forgot to finish the _set_array() and
> > _get_array() helpers for the flowtable, the definition in the header
> > file prooves this.
> > 
> > Can we introduce these new interfaces? Then, update nftables to use it.
> > Then, at some point, set *data_len = 0 for these array datatypes. Yes,
> > it's a bit longer term, but better fix this interface. But setting all
> > these data_len to zero when in most cases it is going to be thereafter
> > properly set to the datatype length is...
> > 
> > Would this work for you? I know it is not so short term.
> 
> While I think your patch is the right way to providing a sanitized
> access to the array attributes, I don't think it's really related to
> what my original patch was fixing, which is:
> 
> Right now we are preventing users from passing wrong attribute types to
> getters by checking the attribute length. This does not work for
> NFTNL_CHAIN_DEVICES or NFTNL_FLOWTABLE_DEVICES because they don't set
> data_len. Hence the expression in nftnl_asser() call:
> 
> | nftnl_assert(val, attr, data_len == sizeof(<something>));
> 
> Will lead to comparing with garbage from stack. This may in most cases
> fail as expected, but there's no guarantee.
> 
> Your patch allows to use "a better" getter/setter for those problematic
> attributes, but it doesn't prevent the above from happening.
>
> My first approach was to make nftnl_chain_get_data() and
> nftnl_flowtable_get_data() set:
> 
> | *data_len = 0;
> 
> for the problematic attributes, but the value is not really correct - a
> "more correct" value, e.g.:
> 
> | *data_len = c->dev_array_len * sizeof(char *);
> 
> Could lead to a pass in getter sanitizing by accident although e.g.
> nftnl_chain_get_u64() is completely unfit even if c->dev_array_len was
> 1.
> 
> So I decided to go the safe way and initialize data_len variables to zero
> instead which has the benefit of catching new attributes added later as
> well.
> 
> If you don't like the approach of initializing all data_len variables, I
> would rather suggest to go with setting '*data_len = 0' in _get_data()
> routines as described above. This has the same effect but it's just a
> two lines change. What do you think?

If I apply the patch that I'm attaching, then I use the wrong datatype
helper:

        nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_DEVICES);

And I can see:

libnftnl: attribute 6 assertion failed in flowtable.c:274

--bzwnr6mtl6uux44f
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/chain.c b/src/chain.c
index e25eb0f5934b..e98af1360912 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -371,6 +371,7 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 		*data_len = strlen(c->dev) + 1;
 		return c->dev;
 	case NFTNL_CHAIN_DEVICES:
+		*data_len = 0;
 		return &c->dev_array[0];
 	}
 	return NULL;
diff --git a/src/flowtable.c b/src/flowtable.c
index 6e18dde8242e..18a3c98ea62d 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -237,6 +237,7 @@ const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 		*data_len = sizeof(int32_t);
 		return &c->family;
 	case NFTNL_FLOWTABLE_DEVICES:
+		*data_len = 0;
 		return &c->dev_array[0];
 	case NFTNL_FLOWTABLE_SIZE:
 		*data_len = sizeof(int32_t);

--bzwnr6mtl6uux44f--
