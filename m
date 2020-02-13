Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE007C2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923102073C
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MAe3f06t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgBMMO0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 07:14:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbgBMMO0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 07:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581596064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SZF5xKRnnvWixT37rnG3aqM1g2MWlopAOH7j6fKcnb8=;
        b=MAe3f06tJCsS1+OZXBN0UmGhInYtHI15p05oXV8hDGDJDXcBWlm7trX9rfq/363lyXmq4w
        FKTnBl2dv+X8bu+IoLnD62scro/eJDfaitQHklfmXO5nreDy5enbBE5OMYH+CzsjSTZ0ti
        TyEA74FxRb50xxaJcX7sva1gG3DCTU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-r4hSZm0BOeKRA4H84HyKZA-1; Thu, 13 Feb 2020 07:14:22 -0500
X-MC-Unique: r4hSZm0BOeKRA4H84HyKZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37B3C100551C;
        Thu, 13 Feb 2020 12:14:21 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4E4E1001B0B;
        Thu, 13 Feb 2020 12:14:13 +0000 (UTC)
Date:   Thu, 13 Feb 2020 07:14:10 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 8/9] netfilter: add audit operation field
Message-ID: <20200213121410.b2dsh2kwg3k7xg7e@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <6768f7c7d9804216853e6e9c59e44f8a10f46b99.1577830902.git.rgb@redhat.com>
 <20200106202306.GO795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106202306.GO795@breakpoint.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-06 21:23, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 96cabb095eed..5eab4d898c26 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -379,7 +379,7 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
> >  extern void __audit_fanotify(unsigned int response);
> >  extern void __audit_tk_injoffset(struct timespec64 offset);
> >  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> > -extern void __audit_nf_cfg(const char *name, u8 af, int nentries);
> > +extern void __audit_nf_cfg(const char *name, u8 af, int nentries, int op);
> 
> Consider adding an enum instead of int op.
> 
> >  	if (audit_enabled)
> > -		audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries);
> > +		audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries, 1);
> 
> audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries, AUDIT_XT_OP_REPLACE);
> 
> ... would be a bit more readable than '1'.
> 
> The name is just an example, you can pick something else.

Thanks Florian.

Another question occurs to me about table default policy.

I'd observed previously that if nentries was zero due to an empty table,
then it was due to table registration calls, which resulted from module
loading.  The default policy is NF_ACCEPT (because Rusty didn't want
more email, go figure...).  It occurred to me later that some table
loads took a command line parameter to be able to change the default
policy verdict from NF_ACCEPT to NF_DROP.  In particular, filter FORWARD
hook tables.  Is there a straightforward way to be able to detect this
in all the audit_nf_cfg() callers to be able to log it?  In particular,
in:
	net/bridge/netfilter/ebtables.c: ebt_register_table()
	net/bridge/netfilter/ebtables.c: do_replace_finish()
	net/bridge/netfilter/ebtables.c: __ebt_unregister_table()
	net/netfilter/x_tables.c: xt_replace_table()
	net/netfilter/x_tables.c: xt_unregister_table()

It appears to be stored in the second entry of struct ipt_replace and
struct ip6t_replace, of types struct ipt_standard and struct
ip6t_standard in target.verdict, which doesn't appear to be obvious or
easily accessible from xt_replace_table().  In ebtables, it appears to
be in the policy member of struct ebt_entries.

Both potential solutions are awkward, adding a parameter to pass that
value in, but also trying to reach into the protocol-specific entry
table to find that value.  Would you have a recommendation?  This
assumes that reporting that default policy value is even desired or
required.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

