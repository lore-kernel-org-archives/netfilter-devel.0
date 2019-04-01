Return-Path: <SRS0=mHk2=SD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC084C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 17:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 953B820883
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 17:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbfDARu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:50:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbfDARu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Apr 2019 13:50:27 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04D613087931;
        Mon,  1 Apr 2019 17:50:27 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71C2E5C206;
        Mon,  1 Apr 2019 17:50:16 +0000 (UTC)
Date:   Mon, 1 Apr 2019 13:50:13 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V5 10/10] audit: NETFILTER_PKT: record each
 container ID associated with a netNS
Message-ID: <20190401175013.it2xwndd62svycwl@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
 <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
 <CAHC9VhQpNGaWeb7dY4ooPKXRoGBd9Ri_Z_ZPpoKun4gUhXDOGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQpNGaWeb7dY4ooPKXRoGBd9Ri_Z_ZPpoKun4gUhXDOGA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 01 Apr 2019 17:50:27 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-04-01 10:50, Paul Moore wrote:
> On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> > event standalone records.  Iterate through all potential audit container
> > identifiers associated with a network namespace.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h    |  5 +++++
> >  kernel/audit.c           | 41 +++++++++++++++++++++++++++++++++++++++++
> >  net/netfilter/nft_log.c  | 11 +++++++++--
> >  net/netfilter/xt_AUDIT.c | 11 +++++++++--
> >  4 files changed, 64 insertions(+), 4 deletions(-)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 7fa3194f5342..80ed323feeb5 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -451,6 +451,47 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> >                 audit_netns_contid_add(new->net_ns, contid);
> >  }
> >
> > +/**
> > + * audit_log_netns_contid_list - List contids for the given network namespace
> > + * @net: the network namespace of interest
> > + * @context: the audit context to use
> > + *
> > + * Description:
> > + * Issues a CONTAINER_ID record with a CSV list of contids associated
> > + * with a network namespace to accompany a NETFILTER_PKT record.
> > + */
> > +void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
> > +{
> > +       struct audit_buffer *ab = NULL;
> > +       struct audit_contid *cont;
> > +       bool first = true;
> > +       struct audit_net *aunet;
> > +
> > +       /* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
> > +       rcu_read_lock();
> > +       aunet = net_generic(net, audit_net_id);
> > +       if (!aunet)
> > +               goto out;
> > +       list_for_each_entry_rcu(cont, &aunet->contid_list, list) {
> > +               if (first) {
> 
> This is borderline nit-picky, but it seems like we could get rid of
> "first" and just check to see if "ab" is still NULL.

Yes, this is a better way, thank you.

> > +                       ab = audit_log_start(context, GFP_ATOMIC,
> > +                                            AUDIT_CONTAINER_ID);
> > +                       if (!ab) {
> > +                               audit_log_lost("out of memory in audit_log_netns_contid_list");
> > +                               goto out;
> > +                       }
> > +                       audit_log_format(ab, "contid=");
> > +               } else
> > +                       audit_log_format(ab, ",");
> > +               audit_log_format(ab, "%llu", cont->id);
> > +               first = false;
> > +       }
> > +       audit_log_end(ab);
> > +out:
> > +       rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL(audit_log_netns_contid_list);
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
