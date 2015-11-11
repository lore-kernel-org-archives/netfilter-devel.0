From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Wed, 11 Nov 2015 17:50:26 +0100
Message-ID: <20151111165026.GA20549@salvia>
References: <20151107074939.GA4003@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Philip Whineray <phil@firehol.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbbKKQun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 11:50:43 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6203A1714F0
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 17:50:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5040D5F0
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 17:50:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6D6512301A
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 17:50:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151107074939.GA4003@compaq.slightly-cracked.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 07, 2015 at 07:49:39AM +0000, Philip Whineray wrote:
> Reading these files is impossible in an unprivileged user namespace,
> interfering with various firewall tools. For instance, iptables-save
> relies on reading /proc/net/ip_tables_names to dump only loaded tables.
> 
> Hiding the contents from non-root users does not achieve anything
> practical. Possible values are well-known and the specifics can
> be inferred from a list of loaded modules on most systems.
> 
> Signed-off-by: Philip Whineray <phil@firehol.org>
> ---
> An alternate might be to change the ownership of the files within the
> namespace when it is created:
> 
> https://lists.linuxcontainers.org/pipermail/lxc-users/2014-November/008110.html
> 
> I do not see that there is much advantage to this, it just ties the
> ability to read the files to the ability to create an unprivileged
> namespace.

So I understood this correctly, this approach would set the ownership
of the /proc entry to the corresponding root uid mapping from the
unpriviledged namespace, right? If so, I would prefer that approach.

This is partially leaking the filtering policy to non-root users as it
contains what modules are being used, so you can at least infer how
complex your ruleset is.

And I guess it will not be long time until someone else will follow up
with a similar patch later on to expose the content of
/proc/net/nf_conntrack to get this working on unpriviledged namespaces
too.

Thanks.
