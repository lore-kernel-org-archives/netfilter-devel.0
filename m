From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] netfilter: export sanitized nf_nat.h to INSTALL_HDR_PATH
Date: Sun, 02 Oct 2011 09:01:18 -0400
Message-ID: <4E88609E.2030404@opensource.dyc.edu>
References: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu> <4E8753C6.1020304@opensource.dyc.edu> <alpine.LNX.2.01.1110021451540.12367@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from virtual.dyc.edu ([67.222.116.22]:41945 "EHLO virtual.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1JBNBV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:01:21 -0400
In-Reply-To: <alpine.LNX.2.01.1110021451540.12367@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/02/2011 08:53 AM, Jan Engelhardt wrote:
> On Saturday 2011-10-01 19:54, Anthony G. Basile wrote:
> 
>> As an appendix to this patch, let me add a couple of points:
>>
>> 1) In the union,
>>
>>> +union nf_conntrack_man_proto {
>>> +	__be16 all;
>>> +	__be16 port;
>>> +	__be16 icmp_idnt;
>>> +	__be16 gre_key;
>>> +};
>>
>> I named the one member icmp_idnt to avoid a name collision with "#define
>> icmp_id ..." in <netinet/ip_icmp.h>.  This causes problems in both
>> iptables and miniupnpd.
> 
> Wow that's a horrible thing to do of ip_icmp.h. Such #defines should die 
> because their scope is way too broad.

I know.  I hate it too, and it was not easy to catch.  But how else do
we get around it?  We could do an undef, but that's just as ugly.

-- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
