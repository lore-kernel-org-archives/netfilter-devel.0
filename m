Return-Path: <SRS0=bjic=4D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D56C7114F
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Feb 2020 13:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366B92084E
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Feb 2020 13:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgBONRS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Feb 2020 08:17:18 -0500
Received: from correo.us.es ([193.147.175.20]:54626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgBONRR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Feb 2020 08:17:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36B866F9C8
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Feb 2020 14:17:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23431DA702
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Feb 2020 14:17:17 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 18DF0DA701; Sat, 15 Feb 2020 14:17:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 128A8DA702;
        Sat, 15 Feb 2020 14:17:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Feb 2020 14:17:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E9D9B42EF4E0;
        Sat, 15 Feb 2020 14:17:14 +0100 (CET)
Date:   Sat, 15 Feb 2020 14:17:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] src: Fix nftnl_assert() on data_len
Message-ID: <20200215131713.5gwn4ayk2udjff33@salvia>
References: <20200214172417.11217-1-phil@nwl.cc>
 <20200214173247.2wbrvcqilqfmcqq5@salvia>
 <20200214173450.GR20005@orbyte.nwl.cc>
 <20200214174200.4xrvnlb72qebtvnb@salvia>
 <20200215004311.GS20005@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vei32ydyagi4dhlj"
Content-Disposition: inline
In-Reply-To: <20200215004311.GS20005@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--vei32ydyagi4dhlj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 15, 2020 at 01:43:11AM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Feb 14, 2020 at 06:42:00PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Feb 14, 2020 at 06:34:50PM +0100, Phil Sutter wrote:
> > > On Fri, Feb 14, 2020 at 06:32:47PM +0100, Pablo Neira Ayuso wrote:
> > > > On Fri, Feb 14, 2020 at 06:24:17PM +0100, Phil Sutter wrote:
> > > > > Typical idiom for *_get_u*() getters is to call *_get_data() and make
> > > > > sure data_len matches what each of them is returning. Yet they shouldn't
> > > > > trust *_get_data() to write into passed pointer to data_len since for
> > > > > chains and NFTNL_CHAIN_DEVICES attribute, it does not. Make sure these
> > > > > assert() calls trigger in those cases.
> > > > 
> > > > The intention to catch for unset attributes through the assertion,
> > > > right?
> > > 
> > > No, this is about making sure that no wrong getter is called, e.g.
> > > nftnl_chain_get_u64() with e.g. NFTNL_CHAIN_HOOKNUM attribute which is
> > > only 32bits.
> > 
> > I think it will also catch the case I'm asking. If attribute is unset,
> > then nftnl_chain_get_data() returns NULL and the assertion checks
> > data_len, which has not been properly initialized.
> 
> With nftnl_assert() being (shortened):
> 
> | #define nftnl_assert(val, attr, expr) \
> |  ((!val || expr) ? \
> |  (void)0 : __nftnl_assert_fail(attr, __FILE__, __LINE__))
> 
> Check for 'expr' (which is passed as 'data_len == sizeof(<something>)')
> will only happen if 'val' is not NULL. Callers then return like so:
> 
> | return val ? *val : 0;
> 
> This means that if you pass an unset attribute to the getter, it will
> simply return 0.

Thanks for explaining, Phil. If the problem is just
NFTNL_CHAIN_DEVICES and NFTNL_FLOWTABLE_DEVICES, probably this is just
fine? So zero data-length is reversed for arrays and update
nftnl_assert() to skip data_len == 0, ie.

> | #define nftnl_assert(val, attr, expr) \
> |  ((!val || data_len == 0 || expr) ? \
> |  (void)0 : __nftnl_assert_fail(attr, __FILE__, __LINE__))

--vei32ydyagi4dhlj
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/utils.h b/include/utils.h
index 8af5a8e973fa..53999c982c56 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -30,7 +30,7 @@ void __noreturn __abi_breakage(const char *file, int line, const char *reason);
 void __nftnl_assert_fail(uint16_t attr, const char *filename, int line);
 
 #define nftnl_assert(val, attr, expr)			\
-  ((!val || expr)					\
+  ((!val || data_len == 0 || expr)			\
    ? (void)0						\
    : __nftnl_assert_fail(attr, __FILE__, __LINE__))
 
diff --git a/src/chain.c b/src/chain.c
index b4066e4d4e88..94a9e43a1754 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -364,6 +364,7 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 		*data_len = strlen(c->dev) + 1;
 		return c->dev;
 	case NFTNL_CHAIN_DEVICES:
+		*data_len = 0;
 		return &c->dev_array[0];
 	}
 	return NULL;
diff --git a/src/flowtable.c b/src/flowtable.c
index 1e235d0ba50f..635322d7fa56 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -230,6 +230,7 @@ const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 		*data_len = sizeof(int32_t);
 		return &c->family;
 	case NFTNL_FLOWTABLE_DEVICES:
+		*data_len = 0;
 		return &c->dev_array[0];
 	case NFTNL_FLOWTABLE_SIZE:
 		*data_len = sizeof(int32_t);

--vei32ydyagi4dhlj--
