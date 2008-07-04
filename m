From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: quote variables in release.sh
Date: Fri, 04 Jul 2008 09:39:27 +0200
Message-ID: <486DD3AF.6040909@netfilter.org>
References: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr> <486DD32C.6040903@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay-ev.club-internet.fr ([194.158.96.209]:52648 "EHLO
	relay-ev.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYGDHj2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 03:39:28 -0400
In-Reply-To: <486DD32C.6040903@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> commit 68a69d9fbf610899aa95457cdd5c38dcfa447c02
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Jul 3 19:23:39 2008 +0200
>>
>>     build: quote variables in release.sh
> 
> Actually, instead of fixing release.sh, we should have the `make
> distcheck' magic working. Currently it is broken.

I mean the magic to build the tarball, of course.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
