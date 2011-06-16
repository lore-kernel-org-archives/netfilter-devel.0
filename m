From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/15] netfilter: ipset: Add xt_action_param to the variant
 level kadt functions, ipset API change
Date: Thu, 16 Jun 2011 18:57:33 +0200
Message-ID: <4DFA35FD.4080404@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-11-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61722 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1FPQ5f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:57:35 -0400
In-Reply-To: <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> With the change the sets can use any parameter available for the match
> and target extensions, like input/output interface. It's required for
> the hash:net,iface set type.

Applied.
