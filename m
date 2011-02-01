From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/13] list:set set type support
Date: Tue, 01 Feb 2011 15:55:34 +0100
Message-ID: <4D481EE6.7010007@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-4-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-5-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-6-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-7-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-8-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-9-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-10-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-11-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-12-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-13-git-send-email-kadlec@blackhole.
 kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43726 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1BAOzf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:55:35 -0500
In-Reply-To: <1296514388-20900-13-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:53, schrieb Jozsef Kadlecsik:
> The module implements the list:set type support in two flavours:
> without and with timeout. The sets has two sides: for the userspace,
> they store the names of other (non list:set type of) sets: one can add,
> delete and test set names. For the kernel, it forms an ordered union of
> the member sets: the members sets are tried in order when elements are
> added, deleted and tested and the process stops at the first success.
> 

Applied, thanks Jozsef.

