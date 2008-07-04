From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build: quote variables in release.sh
Date: Fri, 4 Jul 2008 12:27:57 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807041227510.1890@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr> <486DD32C.6040903@netfilter.org> <486DD3AF.6040909@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYGDK17 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:27:59 -0400
In-Reply-To: <486DD3AF.6040909@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 09:39, Pablo Neira Ayuso wrote:

>Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> commit 68a69d9fbf610899aa95457cdd5c38dcfa447c02
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Thu Jul 3 19:23:39 2008 +0200
>>>
>>>     build: quote variables in release.sh
>> 
>> Actually, instead of fixing release.sh, we should have the `make
>> distcheck' magic working. Currently it is broken.
>
>I mean the magic to build the tarball, of course.

make tarball
