From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/15] netfilter: ipset: Support range for IPv4 at adding/deleting
 elements for hash:*net* types
Date: Thu, 16 Jun 2011 18:53:36 +0200
Message-ID: <4DFA3510.6080604@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61657 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab1FPQxi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:53:38 -0400
In-Reply-To: <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> The range internally is converted to the network(s) equal to the range.
> Example:
> 
> 	# ipset new test hash:net
> 	# ipset add test 10.2.0.0-10.2.1.12
> 	# ipset list test
> 	Name: test
> 	Type: hash:net
> 	Header: family inet hashsize 1024 maxelem 65536
> 	Size in memory: 16888
> 	References: 0
> 	Members:
> 	10.2.1.12
> 	10.2.1.0/29
> 	10.2.0.0/24
> 	10.2.1.8/30

Applied, thanks.
