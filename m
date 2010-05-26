From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] add nflog_snprintf_xml() to output a log in XML format
Date: Wed, 26 May 2010 17:46:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005261744390.1686@obet.zrqbmnf.qr>
References: <20100526123959.6039.31915.stgit@decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36189 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0EZPqg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 11:46:36 -0400
In-Reply-To: <20100526123959.6039.31915.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-05-26 14:39, Pablo Neira Ayuso wrote:

>This patch adds a new function to output the packet in XML format.

One thing always wondered me.. why is is that logging and queuing are 
separate? They seem to be both using netlink to transfer a packet in its 
entirety to userspace.
