Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CDDC34031
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 512F7208C4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zi5vsPdZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgBRWgB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:36:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56977 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726461AbgBRWgB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 17:36:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582065360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6XYHKylbYwWbwgVI0oUf0RytWHiUiJpTboStfvZsvNo=;
        b=Zi5vsPdZqKhrNh7xo5dNP8wXdte+wg7QUpYLLpmulEigYtLtLU5+hvxFr+iWOAOl1Y66TD
        E2Llb7KKmnkZxgohUak05MTLhRt9UUJIb3vXVX69/0DDz/L9Yq39MRRMnNfMh+8KbmPypB
        tEl4BANPEJdyuyW5dBzKVJNtfReZ1Hs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-4PVG-_cgM5azTwe8uV8i-A-1; Tue, 18 Feb 2020 17:35:53 -0500
X-MC-Unique: 4PVG-_cgM5azTwe8uV8i-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF18A18A8C80;
        Tue, 18 Feb 2020 22:35:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C0D785735;
        Tue, 18 Feb 2020 22:35:43 +0000 (UTC)
Date:   Tue, 18 Feb 2020 17:35:40 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 7/9] netfilter: ebtables audit table
 registration
Message-ID: <20200218223540.2apm7spat3z3yyif@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <9f16dee52bac9a3068939283a0122a632ee0438d.1577830902.git.rgb@redhat.com>
 <CAHC9VhS4Cz1T=hycPVz3aCzOpPX-EDzwh284YQ2V5rUM7BJkzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhS4Cz1T=hycPVz3aCzOpPX-EDzwh284YQ2V5rUM7BJkzg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-30 22:18, Paul Moore wrote:
> On Mon, Jan 6, 2020 at 1:56 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Generate audit NETFILTER_CFG records on ebtables table registration.
> >
> > Previously this was only being done for all x_tables operations and
> > ebtables table replacement.
> >
> > Call new audit_nf_cfg() to store table parameters for later use with
> > syscall records.
> >
> > Here is a sample accompanied record:
> >   type=NETFILTER_CFG msg=audit(1494907217.558:5403): table=filter family=7 entries=0
> 
> Wait a minute ... in patch 4 you have code that explicitly checks for
> "entries=0" and doesn't generate a record in that case; is the example
> a lie or is the code a lie? ;)

The example was stale once the entries check was added.  The entries
check has now been removed due to the source of registration records
being orphanned from their syscall record being found and solved in the
ghak120 (norule missing accompanying) issue.

However, there are ebtables nat and filter tables being added that are
being automatically reaped if there are no entries and there is no
syscall accompanying them.  I don't yet know if it is being reaped by
userspace with an async drop, or if it is the kernel that is deciding to
garbage collect that table after a period of disuse.

Some quick instrumentation says it is kernel thread [kworker/u4:2-events_unbound]

pid=153 uid=0 auid=4294967295 tty=(none) ses=4294967295 subj=system_u:system_r:kernel_t:s0 comm="kworker/u4:2" exe=(null)

> > See: https://github.com/linux-audit/audit-kernel/issues/43
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  net/bridge/netfilter/ebtables.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> > index 57dc11c0f349..58126547b175 100644
> > --- a/net/bridge/netfilter/ebtables.c
> > +++ b/net/bridge/netfilter/ebtables.c
> > @@ -1219,6 +1219,8 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
> >                 *res = NULL;
> >         }
> >
> > +       if (audit_enabled)
> > +               audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries);
> >         return ret;
> >  free_unlock:
> >         mutex_unlock(&ebt_mutex);
> > --
> > 1.8.3.1
> 
> --
> paul moore
> www.paul-moore.com
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

