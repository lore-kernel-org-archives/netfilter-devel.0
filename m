From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: ipset: use NFPROTO_ constants
Date: Thu, 25 Aug 2011 23:52:31 +1200
Message-ID: <4E56377F.3070501@treenet.co.nz>
References: <1314264057-5681-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:41227
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1HYL6D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:58:03 -0400
In-Reply-To: <1314264057-5681-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25/08/11 21:20, Jan Engelhardt wrote:
> I have changed the special variant _INET46 to _X_INET46 in
> line with the "X-Something"-style headers that HTTP and mail
> use, and I hope that copying the constants into nfproto.h
> was right (given that nf_inet_addr.h was also copied).
>

Just FYI on that. X-* headers are not great role models. The IETF 
working groups are trying to get them eliminated from the mainstream 
traffic.

AYJ
