From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] Set /proc/net entries owner to root in namespace
Date: Wed, 25 Nov 2015 13:55:08 +0100
Message-ID: <20151125125508.GA27599@salvia>
References: <87a8qbhdps.fsf@x220.int.ebiederm.org>
 <20151122113507.GA5560@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>
To: Philip Whineray <phil@firehol.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37714 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbbKYMzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 07:55:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 461EC1324CE
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:55:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 38513DA860
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:55:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4C67BDA809
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:55:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151122113507.GA5560@compaq.slightly-cracked.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 22, 2015 at 11:35:07AM +0000, Philip Whineray wrote:
> Various files are owned by root with 0440 permission. Reading them is
> impossible in an unprivileged user namespace, interfering with firewall
> tools. For instance, iptables-save relies on /proc/net/ip_tables_names
> contents to dump only loaded tables.
> 
> This patch assigned ownership of the following files to root in the
> current namespace:
> 
> - /proc/net/*_tables_names
> - /proc/net/*_tables_matches
> - /proc/net/*_tables_targets
> - /proc/net/nf_conntrack
> - /proc/net/nf_conntrack_expect
> - /proc/net/netfilter/nfnetlink_log
> 
> A mapping for root must be available, so this order should be followed:
> 
> unshare(CLONE_NEWUSER);
> /* Setup the mapping */
> unshare(CLONE_NEWNET);

Applied, thanks.

