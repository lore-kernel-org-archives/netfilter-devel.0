From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 2/3] libnetlink-log byte alignment
Date: Wed, 18 Jun 2008 16:23:49 +0100
Message-ID: <48592885.3060304@gmx.ch>
References: <1212488472.29489.41.camel@pumper.lan.luxnet.ch> <1213648356.29727.12.camel@pumper.lan.luxnet.ch> <48590A0A.3020102@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34738 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752313AbYFRPXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:23:53 -0400
In-Reply-To: <48590A0A.3020102@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Fabian Hugelshofer wrote:
>> This patch increases portability, but alignment is still not respected
>> in nflog_get_*() which still leaves libnetfilter_log unusable on
>> particular platforms.
> 
> Sorry, I lost track of this alignment issues, what's problem?

I still have problems running the nflog test utility nfunl_test. I get a 
segmentation fault when nflog_get_payload() is called as soon as the 
first packet is received. The other nflog_get* functions which are 
called before work fine (even though I did not check what they return). 
I aligned the receive buffer and actually don't see the reason for the 
segfault.

When I use libnetfilter_log in my own application it works fine as far 
as I can tell. Byte alignment problems are quite non-deterministic and 
the problem with nfunl_test indicates, that there is still a problem around.
