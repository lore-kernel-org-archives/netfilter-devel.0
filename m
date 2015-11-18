From: Phil Whineray <phil@firehol.org>
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Wed, 18 Nov 2015 07:37:24 +0000
Message-ID: <20151118073724.GA4855@compaq.slightly-cracked.com>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
 <87mvudk3r6.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34212 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbKRHh2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 02:37:28 -0500
Received: by wmvv187 with SMTP id v187so264002705wmv.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 23:37:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87mvudk3r6.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 16, 2015 at 03:56:13PM -0600, Eric W. Biederman wrote:
> Philip Whineray <phil@firehol.org> writes:
> 
> > Reading these files is impossible in an unprivileged user namespace,
> > interfering with various firewall tools. For instance, iptables-save
> > relies on reading /proc/net/ip_tables_names to dump only loaded tables.
> 
> These lines are wrong.  They should be:
> 
>         root_uid = make_kuid(net->user_ns, 0);
>         root_gid = make_kgid(net->user_ns, 0);
>         if (!uid_valid(root_uid) || !gid_valid(root_gid))
>         	goto out;
> 
> >  	strlcpy(buf, xt_prefix[af], sizeof(buf));
> >  	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> >  	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
> >  				(void *)(unsigned long)af);
> >  	if (!proc)
> >  		goto out;
> > +	proc_set_user(proc, root_uid, root_gid);

Thanks for the pointer Eric. As written it doesn't quite work because
out is an error path. unshare(CLONE_NEWUSER|CLONE_NEWNET) always fails
due to there not being a mapping for the user yet. Instead:

       root_uid = make_kuid(net->user_ns, 0);
       root_gid = make_kgid(net->user_ns, 0);

followed by:

       if (!proc)
              goto out;
       if (uid_valid(root_uid) && gid_valid(root_gid))
              proc_set_user(proc, root_uid, root_gid);

would preserve the current behaviour but allow the files to be
correctly mapped by first unsharing the user namespace, then setting
the gid map and finally unsharing the namespace.

Or, is it sane to bypass all the above and jump straight to:

        proc_set_user(proc, net->user_ns->owner, net->user_ns->group);

Cheers
Phil
