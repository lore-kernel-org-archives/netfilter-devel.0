From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Mon, 09 Feb 2009 16:13:17 +0100
Message-ID: <4990480D.9060900@trash.net>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57047 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZBIPNT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:13:19 -0500
In-Reply-To: <20090128145826.7501.34671.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the PKTTYPE target which can be used to mangle the
> skbuff packet type field. This target is useful in conjunction with
> the arptables mcmangle target to TCP working again when a
> multicast hardware address is used. An example of its use:
> 
> iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
> 	-j PKTTYPE --to-pkt-type unicast
> 
> Given the following arptables rule-set:
> 
> arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6
> 	\ --mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
> arptables -I INPUT --h-length 6 --destination-mac 01:00:5e:00:01:01
> 	\ -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
> 
> See arptables mcmangle target for further information.

That one refers to this patch :) So you're actually communicating
using TCP and multicast? Why don't you use UDP, which works fine
using multicast without pkttype mangling?



