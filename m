From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter 05/08: nf_conntrack_sip: add TCP support
Date: Thu, 11 Feb 2010 14:01:41 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111400310.30927@obet.zrqbmnf.qr>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet> <20100211073938.7894.59585.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45981 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0BKNBm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:01:42 -0500
In-Reply-To: <20100211073938.7894.59585.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-11 08:39, Patrick McHardy wrote:

>    netfilter: nf_conntrack_sip: add TCP support
>    
>    Add TCP support, which is mandated by RFC3261 for all SIP elements.
>    
>    SIP over TCP is similar to UDP, except that messages are delimited
>    by Content-Length: headers and multiple messages may appear in one
>    packet.

Does it cope with TCP segmentation?
