Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16674C2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 14:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFAA720873
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 14:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtItgN4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBMO35 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:29:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41014 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727076AbgBMO35 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 09:29:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0l9nlLtv0/bHXNek1lDCBUaE0lHasr+bBc4jA0BaTh0=;
        b=UtItgN4qy+/zNskX/eV6DepOXEYEJdRbrfcWZC82YvMyCEY2q3l+dYczJmuorFcfDWDoTx
        SY7uruJ7+At+snYlvSyq7oYrqpsWnr5xRzonYnubzZPqOILFcfiCTkih4oXg6DpPUr2ekN
        fFmXRye7zdbNNrvYgFzyoFPGDrEetK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-PjoBI8_dNuKbyHfpVocn9A-1; Thu, 13 Feb 2020 09:29:54 -0500
X-MC-Unique: PjoBI8_dNuKbyHfpVocn9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68441DBAE;
        Thu, 13 Feb 2020 14:29:53 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 294495DA85;
        Thu, 13 Feb 2020 14:29:45 +0000 (UTC)
Date:   Thu, 13 Feb 2020 09:29:43 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 8/9] netfilter: add audit operation field
Message-ID: <20200213142943.zxa6vwvl45q36zu6@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <6768f7c7d9804216853e6e9c59e44f8a10f46b99.1577830902.git.rgb@redhat.com>
 <20200106202306.GO795@breakpoint.cc>
 <20200213121410.b2dsh2kwg3k7xg7e@madcap2.tricolour.ca>
 <20200213123457.GO2991@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213123457.GO2991@breakpoint.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-02-13 13:34, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > The default policy is NF_ACCEPT (because Rusty didn't want
> > more email, go figure...).  It occurred to me later that some table
> > loads took a command line parameter to be able to change the default
> > policy verdict from NF_ACCEPT to NF_DROP.  In particular, filter FORWARD
> > hook tables.  Is there a straightforward way to be able to detect this
> > in all the audit_nf_cfg() callers to be able to log it?  In particular,
> > in:
> > 	net/bridge/netfilter/ebtables.c: ebt_register_table()
> > 	net/bridge/netfilter/ebtables.c: do_replace_finish()
> > 	net/bridge/netfilter/ebtables.c: __ebt_unregister_table()
> > 	net/netfilter/x_tables.c: xt_replace_table()
> > 	net/netfilter/x_tables.c: xt_unregister_table()
> 
> The module parameter or the policy?
> 
> The poliy can be changed via the xtables tools.
> Given you can have:
> 
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD DROP [0:0]
> :OUTPUT ACCEPT [0:0]
> -A FORWARD -j ACCEPT
> COMMIT
> 
> ... which effectily gives a FORWARD ACCEPT policy I'm not sure logging
> the policy is useful.
> 
> Furthermore, ebtables has polices even for user-defined chains.
> 
> > Both potential solutions are awkward, adding a parameter to pass that
> > value in, but also trying to reach into the protocol-specific entry
> > table to find that value.  Would you have a recommendation?  This
> > assumes that reporting that default policy value is even desired or
> > required.
> 
> See above, I don't think its useful.  If it is needed, its probably best
> to define an informational struct containing the policy (accept/drop)
> value for the each hook points (prerouting to postrouting),  fill
> that from the backend specific code (as thats the only place that
> exposes the backend specific structs ...) and then pass that to
> the audit logging functions.

Ok, for this set, I'll drop the idea.  If it becomes apparent later than
it is necessary, it can be added as a field at the end of the record.

Thanks for looking at this.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

