From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-compat PATCH] iptables: add xtables-compat.8 manpage
Date: Wed, 20 Jan 2016 14:57:43 +0100
Message-ID: <20160120135743.GA18168@salvia>
References: <145286711132.19120.16830872786493397972.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33588 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbcATN5s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 08:57:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E93783066C7
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:57:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D4350DA86E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:57:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E01BDDA807
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:57:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145286711132.19120.16830872786493397972.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 15, 2016 at 03:11:51PM +0100, Arturo Borrero Gonzalez wrote:
> This new manpage tries to explain to users how to deal with the new compat
> tools.
> 
> This is really useful for distributions, for example Debian requires a manpage
> per binary. This manpage can be used for all compat tools.

We can find some little time during NetDev 1.1 to meet and reach
consensus on where to go with this. Patrick and Florian are attending
too.
