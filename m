From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Mon, 16 Nov 2015 16:03:21 -0600
Message-ID: <87vb91iouu.fsf@x220.int.ebiederm.org>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
	<alpine.DEB.2.10.1511151951050.9313@blackhole.kfki.hu>
	<20151116115659.GA16976@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Philip Whineray <phil@firehol.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:33021 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbKPWLc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 17:11:32 -0500
In-Reply-To: <20151116115659.GA16976@salvia> (Pablo Neira Ayuso's message of
	"Mon, 16 Nov 2015 12:56:59 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Sun, Nov 15, 2015 at 07:53:53PM +0100, Jozsef Kadlecsik wrote:
>> Hi Philip,
>> 
>> On Sat, 14 Nov 2015, Philip Whineray wrote:
>> 
>> > Since it's in danger of getting quite complicate, would one or more of
>> > the following be acceptable?
>> > 
>> > - Choose permission in a module parameter
>> > 
>> > - Allow setting with sysctl e.g. net.netfilter.conf.xtable_proc_perms
>> > 
>> > - Match permissions of /proc/modules (grsec restricts these so we will
>> >   gain the same policy).
>> 
>> In my opinion either one is good and I'd pick the sysctl setting. That way 
>> the permissions could be changed without reloading the module and 
>> independently of the permissions of /proc/modules.
>
> I'd rather not to have a sysctl for this thing.
>
> I suspect it will not take long until someone else will follow up with
> a similar patch /proc/net/nf_conntrack.
>
> What is the plan of namespace people for unprivileged namespaces with
> non-world readable /proc entries?

If it makes sense to have them per namespace and allow manipulation by
the user namespace root, the plan is to make the files owned by the
root user in the user namespace that created the network namespace.

That preserves all of the existing logic.

If we don't trust the user namespace root to read/write the file we
probably want to just avoid creating the file altogether if
(net->user_ns != init_user_ns).

Eric
