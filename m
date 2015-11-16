From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Mon, 16 Nov 2015 12:56:59 +0100
Message-ID: <20151116115659.GA16976@salvia>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
 <alpine.DEB.2.10.1511151951050.9313@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Philip Whineray <phil@firehol.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48103 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbKPL5F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 06:57:05 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 12ABC1373D0
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:57:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04D0A1788F9
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:57:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 237501788ED
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:57:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1511151951050.9313@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 15, 2015 at 07:53:53PM +0100, Jozsef Kadlecsik wrote:
> Hi Philip,
> 
> On Sat, 14 Nov 2015, Philip Whineray wrote:
> 
> > Since it's in danger of getting quite complicate, would one or more of
> > the following be acceptable?
> > 
> > - Choose permission in a module parameter
> > 
> > - Allow setting with sysctl e.g. net.netfilter.conf.xtable_proc_perms
> > 
> > - Match permissions of /proc/modules (grsec restricts these so we will
> >   gain the same policy).
> 
> In my opinion either one is good and I'd pick the sysctl setting. That way 
> the permissions could be changed without reloading the module and 
> independently of the permissions of /proc/modules.

I'd rather not to have a sysctl for this thing.

I suspect it will not take long until someone else will follow up with
a similar patch /proc/net/nf_conntrack.

What is the plan of namespace people for unprivileged namespaces with
non-world readable /proc entries?
