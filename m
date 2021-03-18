Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8A4C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 18:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5B664F1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 18:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCRShv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 14:37:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232646AbhCRShY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 14:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616092643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y/khS+sazdkYugBBDua/03KWhTNI7Fdu6w81m6ZyuKs=;
        b=JldcGZM+RzWcN6ADkVHGwJXzvKzzVYmuqE8ccZPTWZ+jOm86eR2l2jx56vd9wEPLsapvqA
        aavd4sTEP40323BlvRBQZwnO9iyrlAEsz31+uLZSynQ1+5IQ5+HUQA1ahvv6eJpEpSm3mP
        5D9z5eV3ljw+mEPwi+DKxCzsmL0Fy8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-iwcR_YGZNWq_3ryKGhEjUA-1; Thu, 18 Mar 2021 14:37:19 -0400
X-MC-Unique: iwcR_YGZNWq_3ryKGhEjUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB47C19251A0;
        Thu, 18 Mar 2021 18:37:17 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8ECA60C13;
        Thu, 18 Mar 2021 18:37:05 +0000 (UTC)
Date:   Thu, 18 Mar 2021 14:37:03 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH] audit: log nftables configuration change events once per
 table
Message-ID: <20210318183703.GL3141668@madcap2.tricolour.ca>
References: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
 <20210318163032.GS5298@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318163032.GS5298@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-18 17:30, Phil Sutter wrote:
> Hi,
> 
> On Thu, Mar 18, 2021 at 11:39:52AM -0400, Richard Guy Briggs wrote:
> > Reduce logging of nftables events to a level similar to iptables.
> > Restore the table field to list the table, adding the generation.
> 
> This looks much better, a few remarks below:
> 
> [...]
> > +static const u8 nft2audit_op[] = { // enum nf_tables_msg_types
> > +	/* NFT_MSG_NEWTABLE	*/	AUDIT_NFT_OP_TABLE_REGISTER,
> > +	/* NFT_MSG_GETTABLE	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELTABLE	*/	AUDIT_NFT_OP_TABLE_UNREGISTER,
> > +	/* NFT_MSG_NEWCHAIN	*/	AUDIT_NFT_OP_CHAIN_REGISTER,
> > +	/* NFT_MSG_GETCHAIN	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELCHAIN	*/	AUDIT_NFT_OP_CHAIN_UNREGISTER,
> > +	/* NFT_MSG_NEWRULE	*/	AUDIT_NFT_OP_RULE_REGISTER,
> > +	/* NFT_MSG_GETRULE	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELRULE	*/	AUDIT_NFT_OP_RULE_UNREGISTER,
> > +	/* NFT_MSG_NEWSET	*/	AUDIT_NFT_OP_SET_REGISTER,
> > +	/* NFT_MSG_GETSET	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELSET	*/	AUDIT_NFT_OP_SET_UNREGISTER,
> > +	/* NFT_MSG_NEWSETELEM	*/	AUDIT_NFT_OP_SETELEM_REGISTER,
> > +	/* NFT_MSG_GETSETELEM	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELSETELEM	*/	AUDIT_NFT_OP_SETELEM_UNREGISTER,
> > +	/* NFT_MSG_NEWGEN	*/	AUDIT_NFT_OP_GEN_REGISTER,
> > +	/* NFT_MSG_GETGEN	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_TRACE	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_NEWOBJ	*/	AUDIT_NFT_OP_OBJ_REGISTER,
> > +	/* NFT_MSG_GETOBJ	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELOBJ	*/	AUDIT_NFT_OP_OBJ_UNREGISTER,
> > +	/* NFT_MSG_GETOBJ_RESET	*/	AUDIT_NFT_OP_OBJ_RESET,
> > +	/* NFT_MSG_NEWFLOWTABLE	*/	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> > +	/* NFT_MSG_GETFLOWTABLE	*/	AUDIT_NFT_OP_INVALID,
> > +	/* NFT_MSG_DELFLOWTABLE	*/	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> > +	/* NFT_MSG_MAX		*/	AUDIT_NFT_OP_INVALID,
> > +};
> 
> NFT_MSG_MAX is itself not a valid message, it serves merely as an upper
> bound for arrays, loops or sanity checks. You will never see it in
> trans->msg_type.
> 
> Since enum nf_tables_msg_types contains consecutive values from 0 to
> NFT_MSG_MAX, you could write the above more explicitly:
> 
> | static const u8 nft2audit_op[NFT_MSG_MAX] = {
> | 	[NFT_MSG_NEWTABLE]	= AUDIT_NFT_OP_TABLE_REGISTER,
> | 	[NFT_MSG_GETTABLE]	= AUDIT_NFT_OP_INVALID,
> | 	[NFT_MSG_DELTABLE]	= AUDIT_NFT_OP_TABLE_UNREGISTER,
> (And so forth.)
> 
> Not a must, but it clarifies the 1:1 mapping between index and said
> enum. Sadly, AUDIT_NFT_OP_INVALID is non-zero. Otherwise one could skip
> all uninteresting ones.

Yes, ok, I prefer your suggested way of listing them.

Yeah, the fact the values for op= already have a precedent in xtables
limits us.

> [...]
> > @@ -6278,12 +6219,11 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
> >  			    filter->type != NFT_OBJECT_UNSPEC &&
> >  			    obj->ops->type->type != filter->type)
> >  				goto cont;
> > -
> >  			if (reset) {
> >  				char *buf = kasprintf(GFP_ATOMIC,
> > -						      "%s:%llu;?:0",
> > +						      "%s:%u",
> >  						      table->name,
> > -						      table->handle);
> > +						      net->nft.base_seq);
> >  
> >  				audit_log_nfcfg(buf,
> >  						family,
> 
> Why did you leave the object-related logs in place? They should reappear
> at commit time just like chains and sets for instance, no?

There are other paths that can trigger these messages that don't go
through nf_tables_commit() that affect the configuration data.  The
counters are considered config data for auditing purposes and the act of
resetting them is audittable.  And the only time we want to emit a
record is when they are being reset.

> Thanks, Phil

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

