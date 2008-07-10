From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: 11/13 [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Thu, 10 Jul 2008 18:28:22 +0200
Message-ID: <1215707302.3262.1.camel@localhost.localdomain>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr>
	 <alpine.LNX.1.10.0807101526530.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:35421 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbYGJQ2x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:28:53 -0400
Received: from wilson.telenet-ops.be (unknown [195.130.132.42])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 58A147109C9
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2008 18:29:14 +0200 (CEST)
In-Reply-To: <alpine.LNX.1.10.0807101526530.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Looks fine to me, one typo: no need to replace "/*" by "/*e" in
ebtables.c

Thanks,
Bart

Op do, 10-07-2008 te 15:28 +0200, schreef Jan Engelhardt:
> commit ffffffffffffffffffffffffffffffffffffffff
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Jul 8 00:42:41 2008 +0200
> 
> [NETFILTER]: Make Ebtables use Xtables infrastructure
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>


