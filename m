From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 20:38:35 +0100
Message-ID: <20151212193835.GA18513@salvia>
References: <n4g4s8$4pr$1@ger.gmane.org>
 <566BEF33.7090501@gmail.com>
 <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
 <566C09F5.6080606@gmail.com>
 <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
 <566C0E75.6080800@familie-kuntze.de>
 <20151212191019.GA10759@salvia>
 <566C73E5.4060500@familie-kuntze.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Remzi =?iso-8859-1?Q?AKY=DCZ?= <linuxliste@gmail.com>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Noel Kuntze <noel@familie-kuntze.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbbLLTir convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 14:38:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E52663C331
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2015 20:38:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D381DDA732
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2015 20:38:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 31413DA7FF
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2015 20:38:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <566C73E5.4060500@familie-kuntze.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 12, 2015 at 08:22:13PM +0100, Noel Kuntze wrote:
> 
> Jeff from #netfilter on Freenode says it is. You should talk
> to him about that.
> "Also, notice a couple other things. First, the old -m state module is deprecated. Now we use conntrack. This module adds a lot more to state tracking, as seen below:"[1]
> 
> [1] http://sfvlug.editthis.info/wiki/Things_You_Should_Know_About_Netfilter

Then please, fix that wiki page and tell other users on #netfilter
that the state match is fine to be used.

Thanks.
