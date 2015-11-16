From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Mon, 16 Nov 2015 12:17:20 +0100
Message-ID: <20151116111720.GA14988@salvia>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35145 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbbKPLR0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 06:17:26 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 986AC1714FB
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:17:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 87EDE1788E8
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:17:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A233A1788E6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:17:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 13, 2015 at 11:59:35AM +0100, Arturo Borrero Gonzalez wrote:
> v2: change functions definitions to static inline if no BUILD_SYSTEMD,
>     and set watchdog variables as static.
> 
> v3: add runtime systemd configuration. Report warnings.

One more question:

This is checking for 'libsystemd >= 227'

Is this library version really required? Or it is simply that you have
set to the most recent version for some reason?

Thanks.
