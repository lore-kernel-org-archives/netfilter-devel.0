From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Ulogd2 beta3 +NFCT - unable to get working
Date: Sat, 27 Jun 2009 23:13:36 +0200
Message-ID: <4A468B80.7090108@netfilter.org>
References: <c4b050a10906231656u53e20855ud5cf5833ca5db7cc@mail.gmail.com>	 <4A426A1C.6050003@netfilter.org> <4A426B0F.3070309@netfilter.org> <c4b050a10906241354w648ffffo50bfa0305f08bee5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbZF0VNt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:13:49 -0400
In-Reply-To: <c4b050a10906241354w648ffffo50bfa0305f08bee5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton VG wrote:
> Yes, it's loaded, here is the list of loaded modules.
> 
> # lsmod|grep nf
> nf_conntrack_netlink    17040  0
> nfnetlink_log           9396  1 xt_NFLOG
> nfnetlink               5176  5 nf_conntrack_netlink,nfnetlink_log
> nf_nat                 19876  1 iptable_nat
> nf_conntrack_ipv4      14472  7 iptable_nat,nf_nat
> nf_defrag_ipv4          2240  1 nf_conntrack_ipv4
> nf_conntrack           70624  7
> xt_connbytes,nf_conntrack_netlink,xt_conntrack,iptable_nat,nf_nat,nf_conntrack_ipv4,sch_esfq
> #
> 
> But I suppose it would not log any connections in case it's not? But
> it does some, but in unpredictable manner.

What do you mean with "unpredictable manner"? Does `conntrack -E' show
events? Did you set CONFIG_NF_CONNTRACK_EVENTS=y in your kernel?

BTW, you have an example config file inside the ulogd2 directory. Have a
look at ulogd2.conf, it contains several useful examples.
