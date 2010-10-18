From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: Install missing ebtables headers for userspace.
Date: Mon, 18 Oct 2010 11:22:43 +0200
Message-ID: <4CBC11E3.3050104@trash.net>
References: <1287089794-15997-1-git-send-email-nbowler@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47616 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab0JRJWp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:22:45 -0400
In-Reply-To: <1287089794-15997-1-git-send-email-nbowler@elliptictech.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.10.2010 22:56, schrieb Nick Bowler:
> The ebt_ip6.h and ebt_nflog.h headers are not not known to Kbuild and
> therefore not installed by make headers_install.  Fix that up.
> 

Applied, thanks.
