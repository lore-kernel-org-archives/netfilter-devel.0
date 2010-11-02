From: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Subject: Re: icmp_error_message return?
Date: Tue, 02 Nov 2010 11:41:31 +0300
Message-ID: <171851288687291@web60.yandex.ru>
References: <48821288638402@web131.yandex.ru> <alpine.LNX.2.01.1011012039090.655@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward3.mail.yandex.net ([77.88.46.8]:50671 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0KBIwN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:52:13 -0400
In-Reply-To: <alpine.LNX.2.01.1011012039090.655@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



01.11.2010, 22:42, "Jan Engelhardt" <jengelh@medozas.de>:
> On Monday 2010-11-01 20:06, "Oleg A. Arkhangelsky" wrote:
>
>> Hello,
>>
>> Maybe I'm wrong, but the last line of icmp_error_message() from
>> net/ipv4/netfilter/nf_conntrack_proto_icmp.c seems illogical to me.
>> Should it be return NF_ACCEPT, instead of -NF_ACCEPT?
>
> (Same with icmpv6.c)
>
> Hmm! Maybe that explains why the ICMPv6 packets from my HE tunnel are
> all -m conntrack --ctstate INVALID?

Very likely. I'm using IPv4 NAT and see ICMP unreachables left my
"outside" interface not translated (with RFC1918 address in src).
Apparently this packets have INVALID state due to invalid return. I'll
check it later.

-- 
wbr, Oleg.
