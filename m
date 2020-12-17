Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A4BC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 12:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8978C206D5
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 12:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgLQMSu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 07:18:50 -0500
Received: from correo.us.es ([193.147.175.20]:37326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgLQMSt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 07:18:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 969771C4376
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 13:17:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 786BEDA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 13:17:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 73CB5DA8F3; Thu, 17 Dec 2020 13:17:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D48E1DA8F3;
        Thu, 17 Dec 2020 13:17:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 13:17:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B52DB426CC84;
        Thu, 17 Dec 2020 13:17:45 +0100 (CET)
Date:   Thu, 17 Dec 2020 13:18:03 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     yang_y_yi@163.com, ovs-dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH] conntrack: fix zone sync issue
Message-ID: <20201217121803.GA27758@salvia>
References: <20201019025313.407244-1-yang_y_yi@163.com>
 <20201216202546.GD10866@p50.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201216202546.GD10866@p50.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Flavio,

The patch below has been in the tree for a while:

https://git.netfilter.org/conntrack-tools/commit/?id=a08af5d26297eb85218a3c3a9e0991001a88cf10

It will be included in the next release.

Thanks.

On Wed, Dec 16, 2020 at 05:25:46PM -0300, Flavio Leitner wrote:
> 
> This email has 'To' field pointing to ovs-dev, but the patch
> seems to fix another code other than OVS.
> 
> You might have realized by now, but in case you're still waiting... :)
> 
> Thanks,
> fbl
> 
> On Mon, Oct 19, 2020 at 10:53:13AM +0800, yang_y_yi@163.com wrote:
> > From: Yi Yang <yangyi01@inspur.com>
> > 
> > In some use cases, zone is used to differentiate different
> > conntrack state tables, so zone also should be synchronized
> > if it is set.
> > 
> > Signed-off-by: Yi Yang <yangyi01@inspur.com>
> > ---
> >  include/network.h | 1 +
> >  src/build.c       | 3 +++
> >  src/parse.c       | 5 +++++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/include/network.h b/include/network.h
> > index 95aad82..20def34 100644
> > --- a/include/network.h
> > +++ b/include/network.h
> > @@ -232,6 +232,7 @@ enum nta_attr {
> >  	NTA_SNAT_IPV6,		/* uint32_t * 4 */
> >  	NTA_DNAT_IPV6,		/* uint32_t * 4 */
> >  	NTA_SYNPROXY,		/* struct nft_attr_synproxy */
> > +	NTA_ZONE,		/* uint16_t */
> >  	NTA_MAX
> >  };
> >  
> > diff --git a/src/build.c b/src/build.c
> > index 99ff230..4771997 100644
> > --- a/src/build.c
> > +++ b/src/build.c
> > @@ -315,6 +315,9 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
> >  	    nfct_attr_is_set(ct, ATTR_SYNPROXY_ITS) &&
> >  	    nfct_attr_is_set(ct, ATTR_SYNPROXY_TSOFF))
> >  		ct_build_synproxy(ct, n);
> > +
> > +	if (nfct_attr_is_set(ct, ATTR_ZONE))
> > +	    ct_build_u16(ct, ATTR_ZONE, n, NTA_ZONE);
> >  }
> >  
> >  static void
> > diff --git a/src/parse.c b/src/parse.c
> > index 7e524ed..e97a721 100644
> > --- a/src/parse.c
> > +++ b/src/parse.c
> > @@ -205,6 +205,11 @@ static struct ct_parser h[NTA_MAX] = {
> >  		.parse	= ct_parse_synproxy,
> >  		.size	= NTA_SIZE(sizeof(struct nta_attr_synproxy)),
> >  	},
> > +	[NTA_ZONE] = {
> > +		.parse	= ct_parse_u16,
> > +		.attr	= ATTR_ZONE,
> > +		.size	= NTA_SIZE(sizeof(uint16_t)),
> > +	},
> >  };
> >  
> >  static void
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > dev mailing list
> > dev@openvswitch.org
> > https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 
> -- 
> fbl
