From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: icmp_error_message return?
Date: Thu, 04 Nov 2010 10:34:31 +0900 (JST)
Message-ID: <201011040134.oA41YVtE005603@toshiba.co.jp>
References: <48821288638402@web131.yandex.ru>
	<alpine.LNX.2.01.1011012039090.655@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sysoleg@yandex.ru, netfilter-devel@vger.kernel.org,
	yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
	pablo@netfilter.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:64277 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0KDBkg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:40:36 -0400
Received: from imx2.toshiba.co.jp (imx2 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id oA41eYjc005361
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Nov 2010 10:40:34 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by imx2.toshiba.co.jp  with ESMTP id oA41YW7Q010362
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Nov 2010 10:34:32 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id oA41YWfM026976
	for netfilter-devel@vger.kernel.org; Thu, 4 Nov 2010 10:34:32 +0900 (JST)
Received: from mx11.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id oA41YWCn027528
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Nov 2010 10:34:32 +0900 (JST)
In-Reply-To: <alpine.LNX.2.01.1011012039090.655@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

From: Jan Engelhardt <jengelh@medozas.de>
Date: Mon, 1 Nov 2010 20:42:55 +0100 (CET)

> On Monday 2010-11-01 20:06, "Oleg A. Arkhangelsky" wrote:
> 
> >Hello,
> >
> >Maybe I'm wrong, but the last line of icmp_error_message() from
> >net/ipv4/netfilter/nf_conntrack_proto_icmp.c seems illogical to me.
> >Should it be return NF_ACCEPT, instead of -NF_ACCEPT?

-NF_ACCEPT should be returned. ICMP error is the special packet and
icmp_error_message() assigns IP_CT_RELATED to ctinfo itself.
nf_conntrack_in() is unnecessary to resolve ctinfo as normal packets,
so icmp_error_message() returns -NF_ACCEPT.


> (Same with icmpv6.c)
> 
> Hmm! Maybe that explains why the ICMPv6 packets from my HE tunnel are 
> all -m conntrack --ctstate INVALID?
> 
> (Ref.: http://www.spinics.net/lists/netfilter-devel/msg13247.html )

I think this is another issue. Maybe fragmentation is related to it ?


-- Yasuyuki Kozakai
