From: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Subject: Re: icmp_error_message return?
Date: Fri, 05 Nov 2010 18:47:56 +0300
Message-ID: <362421288972076@web94.yandex.ru>
References: <48821288638402@web131.yandex.ru>
	<alpine.LNX.2.01.1011012039090.655@obet.zrqbmnf.qr> <201011040134.oA41YVtE005603@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward8.mail.yandex.net ([77.88.61.38]:54414 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0KEP4L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:56:11 -0400
In-Reply-To: <201011040134.oA41YVtE005603@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

04.11.2010, 04:34, "Yasuyuki KOZAKAI" <yasuyuki.kozakai@toshiba.co.jp>:
>>> Maybe I'm wrong, but the last line of icmp_error_message() from
>>> net/ipv4/netfilter/nf_conntrack_proto_icmp.c seems illogical to me.
>>> Should it be return NF_ACCEPT, instead of -NF_ACCEPT?
>
> -NF_ACCEPT should be returned. ICMP error is the special packet and
> icmp_error_message() assigns IP_CT_RELATED to ctinfo itself.
> nf_conntrack_in() is unnecessary to resolve ctinfo as normal packets,
> so icmp_error_message() returns -NF_ACCEPT.
>

Yes, you're right. Overlooked this. Thanks for clarification!

-- 
wbr, Oleg.
