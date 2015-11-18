From: Phil Whineray <phil@firehol.org>
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Wed, 18 Nov 2015 18:39:51 +0000
Message-ID: <20151118183951.GA8325@compaq.slightly-cracked.com>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
 <87mvudk3r6.fsf@x220.int.ebiederm.org>
 <20151118073724.GA4855@compaq.slightly-cracked.com>
 <87a8qbhdps.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35554 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbbKRSj5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 13:39:57 -0500
Received: by wmdw130 with SMTP id w130so210944260wmd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2015 10:39:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87a8qbhdps.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 18, 2015 at 03:13:51AM -0600, Eric W. Biederman wrote:
> Phil Whineray <phil@firehol.org> writes:
> 
> > On Mon, Nov 16, 2015 at 03:56:13PM -0600, Eric W. Biederman wrote:
> >> Philip Whineray <phil@firehol.org> writes:
> >> 
> >> > Reading these files is impossible in an unprivileged user namespace,
> >> > interfering with various firewall tools. For instance, iptables-save
> >> > relies on reading /proc/net/ip_tables_names to dump only loaded tables.
> >> 
> >> These lines are wrong.  They should be:
> >> 
> >>         root_uid = make_kuid(net->user_ns, 0);
> >>         root_gid = make_kgid(net->user_ns, 0);
> >>         if (!uid_valid(root_uid) || !gid_valid(root_gid))
> >>         	goto out;
> >> 
> >> >  	strlcpy(buf, xt_prefix[af], sizeof(buf));
> >> >  	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> >> >  	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
> >> >  				(void *)(unsigned long)af);
> >> >  	if (!proc)
> >> >  		goto out;
> >> > +	proc_set_user(proc, root_uid, root_gid);
> >
> > Thanks for the pointer Eric. As written it doesn't quite work because
> > out is an error path. unshare(CLONE_NEWUSER|CLONE_NEWNET) always fails
> > due to there not being a mapping for the user yet. Instead:
> 
> Point.
> 
> Although CLONE_NEWUSER|CLONE_NEWNET are not required to happen
> simultaneously.
> 
> So you can make what I was suggesting work with:
> unshare(CLONE_NEWUSER);
> /* Setup the mapping */
> unshare(CLONE_NEWNET);
> 
> The simplest version of this I can think of is to just not change the
> user if the mapping is not setup at the time the proc files are created.
> 
> Certainly that would not be worse than what we have today.
> 
> >        root_uid = make_kuid(net->user_ns, 0);
> >        root_gid = make_kgid(net->user_ns, 0);
> >
> > followed by:
> >
> >        if (!proc)
> >               goto out;
> >        if (uid_valid(root_uid) && gid_valid(root_gid))
> >               proc_set_user(proc, root_uid, root_gid);
> >
> > would preserve the current behaviour but allow the files to be
> > correctly mapped by first unsharing the user namespace, then setting
> > the gid map and finally unsharing the namespace.
> 
> I am not quite certain what you are suggesting above.  It looks and
> sounds like my suggest to only call proc_set_user if a mapping exists.
> Which is fine. 

I was indeed trying to get at precisely the same as your suggestion.
Thanks for the much more succinct description.

Patch in due course...

Phil
