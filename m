Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F768CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E8B205F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389046AbfJXJ3I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:29:08 -0400
Received: from correo.us.es ([193.147.175.20]:60628 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732234AbfJXJ3I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 05:29:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA262FB362
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 11:29:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA138D190C
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 11:29:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BFA75DA4D0; Thu, 24 Oct 2019 11:29:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71D8FCA0F2;
        Thu, 24 Oct 2019 11:29:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 24 Oct 2019 11:29:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A81242EE38E;
        Thu, 24 Oct 2019 11:29:01 +0200 (CEST)
Date:   Thu, 24 Oct 2019 11:29:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Use ARRAY_SIZE() macro in nft_strerror()
Message-ID: <20191024092903.sqvoxwwuflk2h4cn@salvia>
References: <20191018155114.7423-1-phil@nwl.cc>
 <20191023112024.gd4dqe6qqv46hufe@salvia>
 <20191023112311.qrglbzhqad4vfqvo@salvia>
 <20191023121627.GM26123@orbyte.nwl.cc>
 <20191023204149.vushra6ipmjqqd7c@salvia>
 <20191024084503.GF17858@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024084503.GF17858@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 10:45:03AM +0200, Phil Sutter wrote:
> Hi,
> 
> On Wed, Oct 23, 2019 at 10:41:49PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Oct 23, 2019 at 02:16:27PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Wed, Oct 23, 2019 at 01:23:11PM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Oct 23, 2019 at 01:20:24PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Fri, Oct 18, 2019 at 05:51:14PM +0200, Phil Sutter wrote:
> > > > > > Variable 'table' is an array of type struct table_struct, so this is a
> > > > > > classical use-case for ARRAY_SIZE() macro.
> > > > > > 
> > > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > 
> > > > > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > 
> > > > BTW, probably good to add the array check?
> > > > 
> > > > https://sourceforge.net/p/libhx/libhx/ci/master/tree/include/libHX/defs.h#l152
> > > 
> > > Copying from kernel sources, do you think that's fine?
> > > 
> > > |  #      ifndef ARRAY_SIZE
> > > | -#              define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
> > > | +#              define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
> > > | +#              define __same_type(a, b) \
> > > | +                       __builtin_types_compatible_p(typeof(a), typeof(b))
> > > | +/*             &a[0] degrades to a pointer: a different type from an array */
> > > | +#              define __must_be_array(a) \
> > > | +                       BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
> > > | +#              define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x))) + __must_be_array(x)
> > > |  #      endif
> > 
> > At quick glance I would say that's fine.
> 
> While testing it, I noticed that gcc has a builtin check already:
> 
> | ../include/xtables.h:640:36: warning: division 'sizeof (const uint32_t * {aka const unsigned int *}) / sizeof (uint32_t {aka const unsigned int})' does not compute the number of array elements [-Wsizeof-pointer-div]
> |   640 | #  define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
> |       |                                    ^
> | nft.c:914:18: note: in expansion of macro 'ARRAY_SIZE'
> |   914 |  for (i = 1; i < ARRAY_SIZE(multp); i++) {
> |       |                  ^~~~~~~~~~
> | nft.c:906:25: note: first 'sizeof' operand was declared here
> |   906 |  static const uint32_t *multp = mult;
> |       |                         ^~~~~
> 
> AFAICT, the only benefit the above brings is that it causes an error
> instead of warning. Do you think we still need it? Maybe instead enable
> -Werror? ;)

If gcc is already checking for this. Warning should be fine.

Regarding -Werror, we would at least need to keep the autogenerated C
code by bison away from it.

IIRC I enabled this in conntrack-tools long time ago, and I started
getting reports on it breaking compilation with new gcc versions that
were actually spewing new warnings. That was stopping users to install
latest, probably -Werror is too agressive?
