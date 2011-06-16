From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 14/15] netfilter: ipset: hash:net,iface type introduced
Date: Thu, 16 Jun 2011 19:01:14 +0200
Message-ID: <4DFA36DA.3060701@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-11-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-13-git-send-email-kadlec@blackhole.
 kfki.hu> <1307465780-28980-14-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-15-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61783 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1FPRBQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:01:16 -0400
In-Reply-To: <1307465780-28980-15-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> The hash:net,iface type makes possible to store network address and
> interface name pairs in a set. It's mostly suitable for egress
> and ingress filtering. Examples:
> 
>         # ipset create test hash:net,iface
>         # ipset add test 192.168.0.0/16,eth0
>         # ipset add test 192.168.0.0/24,eth1

Applied.
