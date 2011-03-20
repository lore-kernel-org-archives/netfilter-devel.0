From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter:ipset: fix address ranges at hash:*port*
 types
Date: Sun, 20 Mar 2011 15:34:04 +0100
Message-ID: <4D86105C.3040403@trash.net>
References: <1300525218-18471-1-git-send-email-kadlec@blackhole.kfki.hu> <1300525218-18471-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1CTOeL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2011 10:34:11 -0400
In-Reply-To: <1300525218-18471-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 19.03.2011 10:00, schrieb Jozsef Kadlecsik:
> The hash:*port* types with IPv4 silently ignored when address ranges
> with non TCP/UDP were added/deleted from the set and used the first
> address from the range only.

Applied, thanks Jozsef.
