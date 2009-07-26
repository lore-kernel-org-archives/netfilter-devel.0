From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: NTP server
Date: Sun, 26 Jul 2009 14:12:42 +1200
Message-ID: <4A6BBB9A.909@treenet.co.nz>
References: <47A7F67C62706041BC49DB7822B1C9DB34D79A8733@INOAVREX11.ptin.corpPT.com>,<4A6A169A.9090704@solutti.com.br> <47A7F67C62706041BC49DB7822B1C9DB34D79A8735@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Leonardo Rodrigues <leolistas@solutti.com.br>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hugo Miguel Mendes <hugo-m-mendes@ptinovacao.pt>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:47478
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZGZCMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 22:12:51 -0400
In-Reply-To: <47A7F67C62706041BC49DB7822B1C9DB34D79A8735@INOAVREX11.ptin.corpPT.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hugo Miguel Mendes wrote:
> Thanks for you attention
> 
> A response coming from another ip is exactly what happens in DCC protocol of IRC, and the module nf_conntrack_irc.ko and nf_nat_irc.ko make it possible by using in the source ip of the expectation the address 0.0.0.0 which works like a wildcard.
> 
> Best Regards
> 
> Hugo Mendes

That being IRC, a protocol where such behaviour is defined.

NTP is direct trusted peer to prevent abuse and protect the little 
structure that depends on it called The Internet.

What would you expect to happen if all your server clocks accepted 
random non-requested packets as truth?

Amos
