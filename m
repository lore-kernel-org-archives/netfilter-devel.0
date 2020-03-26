Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D8AC43331
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 11:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 896F620409
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 11:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgCZLtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 07:49:11 -0400
Received: from correo.us.es ([193.147.175.20]:54374 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgCZLtL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 07:49:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23918EB46E
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 12:49:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 139CDDA7B2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 12:49:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08F52DA736; Thu, 26 Mar 2020 12:49:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B146DA3C2;
        Thu, 26 Mar 2020 12:49:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 12:49:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1CD694251481;
        Thu, 26 Mar 2020 12:49:07 +0100 (CET)
Date:   Thu, 26 Mar 2020 12:49:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3] netfilter: conntrack: export
 nf_ct_acct_update()
Message-ID: <20200326114906.ffi4xojegtipmsbd@salvia>
References: <20200324175009.3118-1-pablo@netfilter.org>
 <cb62c78f-dd8f-5773-0a3b-7ae11ba8839d@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb62c78f-dd8f-5773-0a3b-7ae11ba8839d@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 25, 2020 at 10:59:14AM +0800, wenxu wrote:
> 
> On 3/25/2020 1:50 AM, Pablo Neira Ayuso wrote:
> > This function allows you to update the conntrack counters.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/net/netfilter/nf_conntrack_acct.h |  2 ++
> >  net/netfilter/nf_conntrack_core.c         | 15 +++++++--------
> >  2 files changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
> > index f7a060c6eb28..df198c51244a 100644
> > --- a/include/net/netfilter/nf_conntrack_acct.h
> > +++ b/include/net/netfilter/nf_conntrack_acct.h
> > @@ -65,6 +65,8 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
> >  #endif
> >  }
> >  
> > +void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes);
> > +
> >  void nf_conntrack_acct_pernet_init(struct net *net);
> >  
> >  int nf_conntrack_acct_init(void);
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index a18f8fe728e3..a55c1d6f8191 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -863,9 +863,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
> >  }
> >  EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
> >  
> > -static inline void nf_ct_acct_update(struct nf_conn *ct,
> > -				     enum ip_conntrack_info ctinfo,
> > -				     unsigned int len)
> > +void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes)
> >  {
> >  	struct nf_conn_acct *acct;
> >  
> > @@ -873,10 +871,11 @@ static inline void nf_ct_acct_update(struct nf_conn *ct,
> >  	if (acct) {
> >  		struct nf_conn_counter *counter = acct->counter;
> >  
> > -		atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
> > -		atomic64_add(len, &counter[CTINFO2DIR(ctinfo)].bytes);
> > +		atomic64_inc(&counter[dir].packets);
> > +		atomic64_add(bytes, &counter[dir].bytes);
> >  	}
> >  }
> > +EXPORT_SYMBOL_GPL(nf_ct_acct_update);
> 
> This function only add one packet once. Maybe is not so suit for all the scenario
> 
> such as the HW flowtable offload get the counter from HW periodicly.

This patchset is not addressing the flowtable HW offload.

That will need something like nf_ct_acct_add() to accumulate packets
and bytes. Probably nf_ct_acct_update() should be a static inline that
calls nf_ct_acct_add().
