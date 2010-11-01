From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: icmp_error_message return?
Date: Mon, 1 Nov 2010 20:42:55 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011012039090.655@obet.zrqbmnf.qr>
References: <48821288638402@web131.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Patrick McHardy <kaber@trash.net>, pablo@netfilter.org
To: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44117 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0KATm4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:42:56 -0400
In-Reply-To: <48821288638402@web131.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-11-01 20:06, "Oleg A. Arkhangelsky" wrote:

>Hello,
>
>Maybe I'm wrong, but the last line of icmp_error_message() from
>net/ipv4/netfilter/nf_conntrack_proto_icmp.c seems illogical to me.
>Should it be return NF_ACCEPT, instead of -NF_ACCEPT?

(Same with icmpv6.c)

Hmm! Maybe that explains why the ICMPv6 packets from my HE tunnel are 
all -m conntrack --ctstate INVALID?

(Ref.: http://www.spinics.net/lists/netfilter-devel/msg13247.html )

