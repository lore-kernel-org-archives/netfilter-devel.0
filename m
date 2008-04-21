From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [PATCH 5/6] NETFILTER: signed tcphoff for	ipv6_skip_exthdr()
 retval
Date: Mon, 21 Apr 2008 14:24:06 +0200
Message-ID: <480C8766.9010802@trash.net>
References: <480558CA.7090800@tiscali.nl> <48062282.4070204@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>, coreteam@netfilter.org,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39005 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbYDUMYN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:24:13 -0400
In-Reply-To: <48062282.4070204@tiscali.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roel Kluin wrote:
> if tcphoff remains unsigned, a negative ipv6_skip_exthdr() return value will
> go unnoticed,

Applied, thanks.
