From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH 3/6 RFC] netfilter: audit only on xtables and ebtables
 syscall rule or standalone
Date: Wed, 24 May 2017 14:09:52 -0400
Message-ID: <20170524180952.GL6203@madcap2.tricolour.ca>
References: <cover.1495124188.git.rgb@redhat.com>
 <ac9a2120311288328a81d3e07a68857ebd32a21b.1495124188.git.rgb@redhat.com>
 <20170524173606.GB7439@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933033AbdEXSKS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 14:10:18 -0400
Content-Disposition: inline
In-Reply-To: <20170524173606.GB7439@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-05-24 19:36, Pablo Neira Ayuso wrote:
> On Thu, May 18, 2017 at 01:21:49PM -0400, Richard Guy Briggs wrote:
> > There were syscall events unsolicited by any audit rule caused by a missing
> > !audit_dummy_context() check before creating an
> > iptables/ip6tables/arptables/ebtables NETFILTER_CFG record.  Check
> > !audit_dummy_context() before creating the NETFILTER_CFG record.
> > 
> > The vast majority of observed unaccompanied records are caused by the fedora
> > default rule: "-a never,task" and the occasional early startup one is I believe
> > caused by the iptables filter table module hard linked into the kernel rather
> > than a loadable module. The !audit_dummy_context() check above should avoid
> > them.  Audit only when there is an existing syscall audit rule, otherwise issue
> > a standalone record only on table modification rather than empty table
> > creation.
> > 
> > Add subject attributes to the new standalone NETFILTER_CFGSOLO record using
> > a newly exported audit_log_task().
> 
> This new NETFILTER_CFGSOLO looks like audit infra is missing some way
> to export a revision / context to userspace? It's duplicating quite a
> bit of the code from what I can see in this patch.

Interesting you brought that up.  I did another revision that stores
this information in a struct audit_context and greatly simplifies the
code in netfilter and re-uses code in audit itself, which may be a
better way to go, but that idea needed to settle a bit more before
seeing peer review.
> 
I'm also having doubts about two record types.

> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 0714a66..8bee3f5 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -112,6 +112,7 @@
> >  #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
> >  #define AUDIT_REPLACE		1329	/* Replace auditd if this packet unanswerd */
> >  #define AUDIT_KERN_MODULE	1330	/* Kernel Module events */
> > +#define AUDIT_NETFILTER_CFGSOLO	1331	/* Netfilter chain modifications standalone */
> >  
> >  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
> >  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index b2dcbe6..8ac38e6 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2383,7 +2383,7 @@ void __audit_log_kern_module(char *name)
> >  	context->type = AUDIT_KERN_MODULE;
> >  }
> >  
> > -static void audit_log_task(struct audit_buffer *ab)
> > +void audit_log_task(struct audit_buffer *ab)
> >  {
> >  	kuid_t auid, uid;
> >  	kgid_t gid;
> > @@ -2404,6 +2404,7 @@ static void audit_log_task(struct audit_buffer *ab)
> >  	audit_log_untrustedstring(ab, get_task_comm(comm, current));
> >  	audit_log_d_path_exe(ab, current->mm);
> >  }
> > +EXPORT_SYMBOL_GPL(audit_log_task);
> >  
> >  /**
> >   * audit_core_dumps - record information about processes that end abnormally
> > diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> > index 13d7fe2..743f9e6 100644
> > --- a/net/bridge/netfilter/ebtables.c
> > +++ b/net/bridge/netfilter/ebtables.c
> > @@ -1071,12 +1071,25 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
> >  	if (audit_enabled) {
> >  		struct audit_buffer *ab;
> >  
> > -		ab = audit_log_start(current->audit_context, GFP_KERNEL,
> > -				     AUDIT_NETFILTER_CFG);
> > -		if (ab) {
> > -			audit_log_format(ab, "table=%s family=%u entries=%u",
> > -					 repl->name, AF_BRIDGE, repl->nentries);
> > -			audit_log_end(ab);
> > +		if(!audit_dummy_context()) {
> > +			ab = audit_log_start(current->audit_context, GFP_KERNEL,
> > +					     AUDIT_NETFILTER_CFG);
> > +			if (ab) {
> > +				audit_log_format(ab, "family=%u table=%s entries=%u",
> > +						 AF_BRIDGE, repl->name,
> > +						 repl->nentries);
> > +				audit_log_end(ab);
> > +			}
> > +		} else if(repl->nentries) {
> > +			ab = audit_log_start(NULL, GFP_KERNEL,
> > +					     AUDIT_NETFILTER_CFGSOLO);
> > +			if (ab) {
> > +				audit_log_task(ab);
> > +				audit_log_format(ab, " family=%u table=%s entries=%u",
> > +						 AF_BRIDGE, repl->name,
> > +						 repl->nentries);
> > +				audit_log_end(ab);
> > +			}
> 
> If you have no other way, probably it is a good idea to wrap this code 
> around a function, eg. ebt_audit_replace_finish() ?

Yes, sending the values I need into the audit subsystem to avoid
exposing some bits of audit did come to mind.  And it would bring 6
lines here down to one instead of adding 19.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
