From: Phil Whineray <phil@firehol.org>
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Mon, 16 Nov 2015 12:57:29 +0000
Message-ID: <20151116125729.GA28607@compaq.slightly-cracked.com>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
 <alpine.DEB.2.10.1511151951050.9313@blackhole.kfki.hu>
 <20151116115659.GA16976@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jan Engelhardt <jengelh@inai.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:32823 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbbKPM5k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 07:57:40 -0500
Received: by wmec201 with SMTP id c201so174907330wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 04:57:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151116115659.GA16976@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 16, 2015 at 12:56:59PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 15, 2015 at 07:53:53PM +0100, Jozsef Kadlecsik wrote:
> > Hi Philip,
> > 
> > On Sat, 14 Nov 2015, Philip Whineray wrote:
> > 
> > > Since it's in danger of getting quite complicate, would one or more of
> > > the following be acceptable?
> > > 
> > > - Choose permission in a module parameter
> > > 
> > > - Allow setting with sysctl e.g. net.netfilter.conf.xtable_proc_perms
> > > 
> > > - Match permissions of /proc/modules (grsec restricts these so we will
> > >   gain the same policy).
> > 
> > In my opinion either one is good and I'd pick the sysctl setting. That way 
> > the permissions could be changed without reloading the module and 
> > independently of the permissions of /proc/modules.
> 
> I'd rather not to have a sysctl for this thing.
> 
> I suspect it will not take long until someone else will follow up with
> a similar patch /proc/net/nf_conntrack.

That may be true. The two are not equivalent though: the nf_conntrack
information is per-namespace (so setting owner to root in the current
namespace would certainly be sensible), whereas the information in
ip_tables_names is global and directly relates to modules loaded.

> What is the plan of namespace people for unprivileged namespaces with
> non-world readable /proc entries?

It may not have come up as an issue: a quick survey on my systems suggests
pretty much only only netfilter creates files which are group readable but
not world readable:

$ sudo find /proc/ -perm /g=r -a \! -perm /o=r | sed \
     's:proc/[0-9]*/:proc/0/:' | sort -u | less
/proc/0/net/ip6_tables_matches
/proc/0/net/ip6_tables_names
/proc/0/net/ip6_tables_targets
/proc/0/net/ip_tables_matches
/proc/0/net/ip_tables_names
/proc/0/net/ip_tables_targets
/proc/0/net/netfilter/nfnetlink_log
/proc/0/net/nf_conntrack
/proc/0/net/nf_conntrack_expect
