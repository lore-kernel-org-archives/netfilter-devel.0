From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Wed, 19 Jun 2013 12:47:18 +0300
Message-ID: <51C17E26.2020608@linux.intel.com>
References: <1371628997-13548-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62796 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993Ab3FSJrV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:47:21 -0400
In-Reply-To: <1371628997-13548-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,
> The patch
> 	netfilter: nf_tables: add insert operation
> adds support for inserting a rule after a handle.
>
> It is followed by the patch
> 	examples: add insert rule example
> which is the libnftables example.
>
> I choose to reuse the CREATE operation in the kernel code
> to avoid to add a new message to netlink. This way we have
> a sort of 'create after' syntax. This is almost natural IMHO.

There is an issue however: notification.
I don't see how other clients are going to know where to put the rule 
when updating there own list when they get notified.

They will be notified that a rule as been added successfully, but they 
will get it as an appended rule.

Here it's a one shot usage: only on creating you need this info, so it 
would be also provided on notification. Not on the dump obviously.
I don't see a direct solution here, since adding an attribute (or a new 
flag to NFTA_RULE_FLAGS) would be going against current API design.

We have to sort this out.

Tomasz
