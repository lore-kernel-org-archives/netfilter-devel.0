From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] netfilter: export sanitized nf_nat.h to INSTALL_HDR_PATH
Date: Sat, 01 Oct 2011 13:54:14 -0400
Message-ID: <4E8753C6.1020304@opensource.dyc.edu>
References: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from virtual.dyc.edu ([67.222.116.22]:44502 "EHLO virtual.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1JARyR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:54:17 -0400
In-Reply-To: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As an appendix to this patch, let me add a couple of points:

1) In the union,

> +union nf_conntrack_man_proto {
> +	__be16 all;
> +	__be16 port;
> +	__be16 icmp_idnt;
> +	__be16 gre_key;
> +};

I named the one member icmp_idnt to avoid a name collision with "#define
icmp_id ..." in <netinet/ip_icmp.h>.  This causes problems in both
iptables and miniupnpd.


2) Pushing this down to iptables would require constructions like

   range.min.tcp.port

to be replaced by

    range.min.port

and similarly for range.max.tcp.port, in

    extentions/libipt_{DNAT,MASQUERADE,NETMAP,REDIRECT,SAME,SNAT}.c

Of course, you would also replace

  #include <net/netfilter/nf_nat.h>

with

  #include <linux/netfilter/nf_nat.h>

and no longer need to ship

   include/net/netfilter/{nf_nat.h,nf_conntrack_tuple.h}

with iptables.

I've tested both iptables and miniupnpd with these changes and no
problems.  I'll provide a patch when the time comes.


-- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
