From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/8] [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Wed, 09 Apr 2008 15:08:15 +0200
Message-ID: <47FCBFBF.5020805@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <00e063673b63941c85b10b43cd1edec966d32e54.1207668694.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45622 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYDINIW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:08:22 -0400
In-Reply-To: <00e063673b63941c85b10b43cd1edec966d32e54.1207668694.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>


I like these patches (modulo the small NFPROTO_ARP nitpicks),
I'd like to get an ACK from Bart before applying them though.

I assume this doesn't affect userspace compatibility?
