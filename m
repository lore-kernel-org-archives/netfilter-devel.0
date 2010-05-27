From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add nflog_snprintf_xml() to output a log in XML format
Date: Thu, 27 May 2010 13:56:41 +0200
Message-ID: <4BFE5DF9.4010200@netfilter.org>
References: <20100526123959.6039.31915.stgit@decadence> <alpine.LSU.2.01.1005261744390.1686@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42731 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab0E0L4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 07:56:47 -0400
In-Reply-To: <alpine.LSU.2.01.1005261744390.1686@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-05-26 14:39, Pablo Neira Ayuso wrote:
> 
>> This patch adds a new function to output the packet in XML format.
> 
> One thing always wondered me.. why is is that logging and queuing are 
> separate? They seem to be both using netlink to transfer a packet in its 
> entirety to userspace.

Nowadays, the logging infrastructure can be simplified if we use netlink
multicast instead. At the time the logging infrastructure was done,
netlink only supported 32 multicast groups. Thus, it was not possible to
implement it upon multicast.

They indeed look quite similar with the minor difference that logging
has no verdicts and it contains the string prefix in the messages.

Probably Patrick can provide more reasons.
