From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: nat drop the icmp redirect packet
Date: Mon, 28 Nov 2011 09:23:48 +0800
Message-ID: <4ED2E2A4.6000505@cn.fujitsu.com>
References: <4ED2E00B.3000006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab1K1BXj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:23:39 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id AF47617011A
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2011 09:23:35 +0800 (CST)
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id pAS1NZHL005617
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2011 09:23:35 +0800
In-Reply-To: <4ED2E00B.3000006@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D3=DA 2011=C4=EA11=D4=C228=C8=D5 09:12, Gao feng =D0=B4=B5=C0:
> Hi
>=20
> In func nf_nat_icmp_reply_translation,the icmp packet will be droped =
when the nat is not finished.
> pc A(whose gateway is C) send a icmp request to pc B.
> When gw C receive this packet,it may return a icmp redirect packet to=
 A.
> BUT now,the icmp request packet has not go to POSTROUTING,So the nat =
is not finished.
> Finally,the icmp redirect packet will be droped no matter the conn ha=
s nat or not.
>=20
> of course,the icmp redirect packet will be correct handled when nat i=
s finished.
>=20
> Can somebody will give me some suggestion,
> or should I just add a sysctl to let the user decide drop or receive =
this icmp redirect packet when nat is not finished?
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

or maybe we can move the ip_rt_send_redirect from FORWARD to POSTROUTIN=
G?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
