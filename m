From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/15] netfilter: ipset: Set type support with multiple
 revisions added
Date: Thu, 16 Jun 2011 18:52:23 +0200
Message-ID: <4DFA34C7.9070904@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61640 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab1FPQw0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:52:26 -0400
In-Reply-To: <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> A set type may have multiple revisions, for example when syntax is extended.
> Support continuous revision ranges in set types.

Applied.
