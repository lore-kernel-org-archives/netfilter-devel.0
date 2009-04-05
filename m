From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] iptables-1.4.3.1: unabled to restore ! -s 192.168.1.0/24
 match
Date: Sun, 5 Apr 2009 13:41:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904051337180.7501@fbirervta.pbzchgretzou.qr>
References: <49C8DB3B.909@netfilter.org> <1238838634.31963.578.camel@localhost> <alpine.LSU.2.00.0904041334001.13174@fbirervta.pbzchgretzou.qr> <49D88697.6010609@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Volkov <pva@gentoo.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43446 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZDELlq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:41:46 -0400
In-Reply-To: <49D88697.6010609@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-04-05 12:23, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Saturday 2009-04-04 11:50, Peter Volkov wrote:
>> 
>>> Hi. We've received bug report about broken ! -s 192.168.1.0/24 match:
>>> http://bugs.gentoo.org/264089
>> 
>> I combined your two patches, added the missing ip6 parts and used
>> the default iptables spacing idioms.
>> 
>> Pablo: This is available through the 'plus' branch at 
>> git://dev.medozas.de/iptables.
>
>There's something in this pull that was not discussed at all:
>
>commit a094eb0f2a57592b6f3cf42fdbb9d49fead2d57c
>Author: Jan Engelhardt <jengelh@medozas.de>
>Date:   Fri Apr 3 22:37:49 2009 +0200
>
>    build: add configure option to disable ipv4 iptables

To my defense, this was previously posted at
http://marc.info/?l=netfilter-devel&m=123879253202869&w=2

It could have been a bit more detailed, I concur. Upping the
verbosity level by one on future pull requests.

>[...]
>This is fine but please, send more detailed reports on the changeset
>that are in your tree.
