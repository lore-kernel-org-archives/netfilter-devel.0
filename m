From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Wed, 18 Nov 2015 03:13:51 -0600
Message-ID: <87a8qbhdps.fsf@x220.int.ebiederm.org>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
	<87mvudk3r6.fsf@x220.int.ebiederm.org>
	<20151118073724.GA4855@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: Phil Whineray <phil@firehol.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:55720 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbbKRJWx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 04:22:53 -0500
In-Reply-To: <20151118073724.GA4855@compaq.slightly-cracked.com> (Phil
	Whineray's message of "Wed, 18 Nov 2015 07:37:24 +0000")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Whineray <phil@firehol.org> writes:

> On Mon, Nov 16, 2015 at 03:56:13PM -0600, Eric W. Biederman wrote:
>> Philip Whineray <phil@firehol.org> writes:
>> 
>> > Reading these files is impossible in an unprivileged user namespace,
>> > interfering with various firewall tools. For instance, iptables-save
>> > relies on reading /proc/net/ip_tables_names to dump only loaded tables.
>> 
>> These lines are wrong.  They should be:
>> 
>>         root_uid = make_kuid(net->user_ns, 0);
>>         root_gid = make_kgid(net->user_ns, 0);
>>         if (!uid_valid(root_uid) || !gid_valid(root_gid))
>>         	goto out;
>> 
>> >  	strlcpy(buf, xt_prefix[af], sizeof(buf));
>> >  	strlcat(buf, FORMAT_TABLES, sizeof(buf));
>> >  	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
>> >  				(void *)(unsigned long)af);
>> >  	if (!proc)
>> >  		goto out;
>> > +	proc_set_user(proc, root_uid, root_gid);
>
> Thanks for the pointer Eric. As written it doesn't quite work because
> out is an error path. unshare(CLONE_NEWUSER|CLONE_NEWNET) always fails
> due to there not being a mapping for the user yet. Instead:

Point.

Although CLONE_NEWUSER|CLONE_NEWNET are not required to happen
simultaneously.

So you can make what I was suggesting work with:
unshare(CLONE_NEWUSER);
/* Setup the mapping */
unshare(CLONE_NEWNET);

The simplest version of this I can think of is to just not change the
user if the mapping is not setup at the time the proc files are created.

Certainly that would not be worse than what we have today.

>        root_uid = make_kuid(net->user_ns, 0);
>        root_gid = make_kgid(net->user_ns, 0);
>
> followed by:
>
>        if (!proc)
>               goto out;
>        if (uid_valid(root_uid) && gid_valid(root_gid))
>               proc_set_user(proc, root_uid, root_gid);
>
> would preserve the current behaviour but allow the files to be
> correctly mapped by first unsharing the user namespace, then setting
> the gid map and finally unsharing the namespace.

I am not quite certain what you are suggesting above.  It looks and
sounds like my suggest to only call proc_set_user if a mapping exists.
Which is fine. 

> Or, is it sane to bypass all the above and jump straight to:
>
>         proc_set_user(proc, net->user_ns->owner, net->user_ns->group);

It is not.   There are many reasons why typically user_ns->owner and
user_ns->group are rarely mapped in a user namespace.

Eric

