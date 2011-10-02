From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: export sanitized nf_nat.h to
 INSTALL_HDR_PATH
Date: Sun, 2 Oct 2011 14:53:09 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1110021451540.12367@frira.zrqbmnf.qr>
References: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu> <4E8753C6.1020304@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55175 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1JBMxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Oct 2011 08:53:11 -0400
In-Reply-To: <4E8753C6.1020304@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-10-01 19:54, Anthony G. Basile wrote:

>As an appendix to this patch, let me add a couple of points:
>
>1) In the union,
>
>> +union nf_conntrack_man_proto {
>> +	__be16 all;
>> +	__be16 port;
>> +	__be16 icmp_idnt;
>> +	__be16 gre_key;
>> +};
>
>I named the one member icmp_idnt to avoid a name collision with "#define
>icmp_id ..." in <netinet/ip_icmp.h>.  This causes problems in both
>iptables and miniupnpd.

Wow that's a horrible thing to do of ip_icmp.h. Such #defines should die 
because their scope is way too broad.
