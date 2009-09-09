From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Some clarifications regarding netfilter / iptables
Date: Wed, 9 Sep 2009 18:43:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909091840310.3737@obet.zrqbmnf.qr>
References: <55120.152.14.80.181.1252512197.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Balaji Venkatamohan <bvenkat@ncsu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59187 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZIIQn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:43:58 -0400
In-Reply-To: <55120.152.14.80.181.1252512197.squirrel@webmail.ncsu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-09-09 18:03, Balaji Venkatamohan wrote:
>
>1. How does the conntrack module code access the header fields of an IP
>packet? Does the accessing of IP packets fall under the functions of
>ip_conntrack module or ip_tables module?

Neither; you do that with, for example, skb_header_pointer, a core
network function.

>2.I want to access the latest version of ip_tables, ip_conntrack and
>ip_conntrack_ftp source code. I need to write a simple module on the lines
>of ip_conntrack to allow a simple connection of my choosing. So I need to
>know where to start coding. I will be grateful if I get some help in this
>regard.

nf_conntrack itself does not "allow" connections. It just tracks them.
Additionally, the 'real work' is done by submodules such as nf_conntrack_ipv4,
nf_conntrack_ipv6, nf_conntrack_proto_sctp, etc.

>3. Is it possible to write our own ip_conntrack module and if yes can we
>define our own state table? Who defines a state table and where is it
>defined?

I think you will be wanting nf_conntrack_proto_tcp.c.
