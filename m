Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5433143C4B
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Feb 2024 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047244; cv=none; b=l1U9HD1ymWtPrQhmf97C+gLiQkDXZZ3hZzZaYl3xKlkEYjKHAGmn/477YezGxZxTOaaSNFlF8hC2x2Spfdj+KXAUN+xO9Wc0WxwqZ/7+xnJjTBghxW4wL+YpEpTyZOSipR6I1WhsksiW+vOwFPkiuoOlUnkLIs3SZ8Tp05RulfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047244; c=relaxed/simple;
	bh=G4dCnOmsZlDF0FxaQhJvlmnmtDNul7vmbGDCcumRLB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRQ1dCaFLORjljf0Ql3BrXaefYjQS3JHyoPZjPWh/KRN485oX231RZxgbgGDmAhYM1D4rxsrLJPPLIyvl94kWL5PXaK8pSx3hsz4bZ90eZ17QiGol6hfYP+h5QNaMtTXz/CyK/KVilkw3eJ+QKROZF8pKO0RAFasL23nTqTLtXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=35696 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rezFs-0031fH-GJ; Tue, 27 Feb 2024 16:20:31 +0100
Date: Tue, 27 Feb 2024 16:20:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yves Metivier <yves@metivier.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Ulogd2 Mysql KO
Message-ID: <Zd39u1cl23cPMt3S@calendula>
References: <8ece704d-145c-4d8c-bdbe-9586cb4b073f@metivier.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ece704d-145c-4d8c-bdbe-9586cb4b073f@metivier.fr>
X-Spam-Score: -1.9 (-)

On Tue, Feb 27, 2024 at 10:26:16AM +0100, Yves Metivier wrote:
> Hello,
> 
> first I apologize for ma bad English (I am French, and old...:-)

No problem.

Attached output is garbled by MUA, I suspected, hard to read.

> I can't get ulogd2 and MYSQL to work, altough it works well with LOGEMU.
> After initialization, there are no more messages in the ulogd.log Below are
> ulogd.log, ulogd.conf and an extract of iptables rules : Ulogd.log =========
> Mon Feb 26 23:41:31 2024 <5> ulogd.c:408 registering plugin `NFLOG' Mon Feb
> 26 23:41:31 2024 <5> ulogd.c:408 registering plugin `IFINDEX' Mon Feb 26
> 23:41:31 2024 <5> ulogd.c:408 registering plugin `IP2BIN' Mon Feb 26
> 23:41:31 2024 <5> ulogd.c:408 registering plugin `IP2STR' Mon Feb 26
> 23:41:31 2024 <5> ulogd.c:408 registering plugin `HWHDR' Mon Feb 26 23:41:31
> 2024 <5> ulogd.c:408 registering plugin `MYSQL' Mon Feb 26 23:41:31 2024 <5>
> ulogd.c:408 registering plugin `BASE' Mon Feb 26 23:41:31 2024 <5>
> ulogd.c:408 registering plugin `PRINTPKT' Mon Feb 26 23:41:31 2024 <5>
> ulogd.c:408 registering plugin `LOGEMU' Mon Feb 26 23:41:31 2024 <5>
> ulogd.c:978 building new pluginstance stack: 'log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU'
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:988 tok=`log1:NFLOG' Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:1025 pushing `NFLOG' on stack Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:988 tok=`base1:BASE' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:1025 pushing `BASE' on stack Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:988 tok=`ifi1:IFINDEX' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025
> pushing `IFINDEX' on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:988
> tok=`ip2str1:IP2STR' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025 pushing
> `IP2STR' on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:988
> tok=`print1:PRINTPKT' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025 pushing
> `PRINTPKT' on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:988
> tok=`emu1:LOGEMU' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025 pushing `LOGEMU'
> on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin `LOGEMU'
> Mon Feb 26 23:41:31 2024 <1> ulogd_output_LOGEMU.c:180 parsing config file
> section emu1 Mon Feb 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin
> `PRINTPKT' Mon Feb 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin
> `IP2STR' Mon Feb 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin
> `IFINDEX' Mon Feb 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin `BASE'
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin `NFLOG' Mon Feb
> 26 23:41:31 2024 <1> ulogd_inppkt_NFLOG.c:557 parsing config file section
> `log1', plugin `NFLOG' Mon Feb 26 23:41:31 2024 <1> ulogd.c:819 connecting
> input/output keys of stack: Mon Feb 26 23:41:31 2024 <1> ulogd.c:826
> traversing plugin `LOGEMU' Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> print1(PRINTPKT) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `print(?)' as source for LOGEMU(print) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.time.sec(?)' as source for LOGEMU(oob.time.sec) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:826 traversing plugin `PRINTPKT' Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `oob.family(?)' as source for PRINTPKT(oob.family) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.prefix(?)' as source for PRINTPKT(oob.prefix) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 ifi1(IFINDEX) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:888 assigning `oob.in(?)' as source for PRINTPKT(oob.in) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 ifi1(IFINDEX) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.out(?)' as source for PRINTPKT(oob.out) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.uid(?)' as source for PRINTPKT(oob.uid) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.gid(?)' as source for PRINTPKT(oob.gid) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.mark(?)' as source for PRINTPKT(oob.mark) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `raw.mac(?)' as source for PRINTPKT(raw.mac) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `raw.mac_len(?)' as source for PRINTPKT(raw.mac_len)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 ip2str1(IP2STR) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `ip.saddr.str(?)' as source for
> PRINTPKT(ip.saddr.str) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> ip2str1(IP2STR) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip.daddr.str(?)' as source for PRINTPKT(ip.daddr.str) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip.totlen(?)' as source for PRINTPKT(ip.totlen) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.tos(?)' as source for PRINTPKT(ip.tos) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.ttl(?)' as source for PRINTPKT(ip.ttl) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.id(?)' as source for PRINTPKT(ip.id) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.fragoff(?)' as source for PRINTPKT(ip.fragoff) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:888 assigning `ip.protocol(?)' as source for
> PRINTPKT(ip.protocol) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `ip6.payloadlen(?)' as
> source for PRINTPKT(ip6.payloadlen) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip6.priority(?)' as source for PRINTPKT(ip6.priority) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip6.hoplimit(?)' as source for PRINTPKT(ip6.hoplimit) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip6.flowlabel(?)' as source for
> PRINTPKT(ip6.flowlabel) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `ip6.nexthdr(?)' as
> source for PRINTPKT(ip6.nexthdr) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip6.fragoff(?)' as source for PRINTPKT(ip6.fragoff) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip6.fragid(?)' as source for PRINTPKT(ip6.fragid) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `tcp.sport(?)' as source for PRINTPKT(tcp.sport) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:888 assigning `tcp.dport(?)' as source for PRINTPKT(tcp.dport)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `tcp.seq(?)' as source for PRINTPKT(tcp.seq)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `tcp.ackseq(?)' as source for
> PRINTPKT(tcp.ackseq) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.window(?)' as source
> for PRINTPKT(tcp.window) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.syn(?)'
> as source for PRINTPKT(tcp.syn) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.ack(?)'
> as source for PRINTPKT(tcp.ack) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.psh(?)'
> as source for PRINTPKT(tcp.psh) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.rst(?)'
> as source for PRINTPKT(tcp.rst) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.fin(?)'
> as source for PRINTPKT(tcp.fin) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.urg(?)'
> as source for PRINTPKT(tcp.urg) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `tcp.urgp(?)'
> as source for PRINTPKT(tcp.urgp) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `udp.sport(?)' as source for PRINTPKT(udp.sport) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `udp.dport(?)' as source for PRINTPKT(udp.dport) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `udp.len(?)' as source for PRINTPKT(udp.len) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `icmp.type(?)' as source for PRINTPKT(icmp.type) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:888 assigning `icmp.code(?)' as source for PRINTPKT(icmp.code)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `icmp.echoid(?)' as source for
> PRINTPKT(icmp.echoid) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `icmp.echoseq(?)' as
> source for PRINTPKT(icmp.echoseq) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `icmp.gateway(?)' as source for PRINTPKT(icmp.gateway) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `icmp.fragmtu(?)' as source for PRINTPKT(icmp.fragmtu) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `icmpv6.type(?)' as source for PRINTPKT(icmpv6.type)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `icmpv6.code(?)' as source for
> PRINTPKT(icmpv6.code) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `icmpv6.echoid(?)' as
> source for PRINTPKT(icmpv6.echoid) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `icmpv6.echoseq(?)' as source for PRINTPKT(icmpv6.echoseq) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ahesp.spi(?)' as source for PRINTPKT(ahesp.spi) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:888 assigning `oob.protocol(?)' as source for
> PRINTPKT(oob.protocol) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `arp.hwtype(?)' as source
> for PRINTPKT(arp.hwtype) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `arp.protocoltype(?)' as source for PRINTPKT(arp.protocoltype) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `arp.operation(?)' as source for
> PRINTPKT(arp.operation) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `arp.shwaddr(?)' as
> source for PRINTPKT(arp.shwaddr) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> ip2str1(IP2STR) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `arp.saddr.str(?)' as source for PRINTPKT(arp.saddr.str) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `arp.dhwaddr(?)' as source for PRINTPKT(arp.dhwaddr) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 ip2str1(IP2STR) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `arp.daddr.str(?)' as source for
> PRINTPKT(arp.daddr.str) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `sctp.sport(?)' as source
> for PRINTPKT(sctp.sport) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `sctp.dport(?)' as source for PRINTPKT(sctp.dport) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:826 traversing plugin `IP2STR' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.family(?)' as source for IP2STR(oob.family) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `oob.protocol(?)' as source for IP2STR(oob.protocol) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.saddr(?)' as source for IP2STR(ip.saddr) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.daddr(?)' as source for IP2STR(ip.daddr) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `arp.saddr(?)' as source for IP2STR(arp.saddr) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `arp.daddr(?)' as source for IP2STR(arp.daddr) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:826 traversing plugin `IFINDEX' Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.ifindex_in(?)' as source for
> IFINDEX(oob.ifindex_in) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log1(NFLOG)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `oob.ifindex_out(?)' as
> source for IFINDEX(oob.ifindex_out) Mon Feb 26 23:41:31 2024 <1> ulogd.c:826
> traversing plugin `BASE' Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `raw.pkt(?)'
> as source for BASE(raw.pkt) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `raw.pktlen(?)' as source for BASE(raw.pktlen) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.family(?)' as source for BASE(oob.family) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log1(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.protocol(?)' as source for BASE(oob.protocol) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:826 traversing plugin `NFLOG' Mon Feb 26 23:41:31 2024 <1>
> ulogd_inppkt_NFLOG.c:598 opening nfnetlink socket Mon Feb 26 23:41:31 2024
> <5> ulogd_inppkt_NFLOG.c:569 forcing unbind of existing log handler for
> protocol 2 Mon Feb 26 23:41:31 2024 <1> ulogd_inppkt_NFLOG.c:580 binding to
> protocol family 2 Mon Feb 26 23:41:31 2024 <5> ulogd_inppkt_NFLOG.c:569
> forcing unbind of existing log handler for protocol 10 Mon Feb 26 23:41:31
> 2024 <1> ulogd_inppkt_NFLOG.c:580 binding to protocol family 10 Mon Feb 26
> 23:41:31 2024 <5> ulogd_inppkt_NFLOG.c:569 forcing unbind of existing log
> handler for protocol 7 Mon Feb 26 23:41:31 2024 <1> ulogd_inppkt_NFLOG.c:580
> binding to protocol family 7 Mon Feb 26 23:41:31 2024 <1>
> ulogd_inppkt_NFLOG.c:614 binding to log group 0 Mon Feb 26 23:41:31 2024 <1>
> ulogd_output_LOGEMU.c:140 starting logemu Mon Feb 26 23:41:31 2024 <1>
> ulogd_output_LOGEMU.c:145 opening file: /var/log/ulogd/ulogd_syslogemu.log
> Mon Feb 26 23:41:31 2024 <5> ulogd.c:978 building new pluginstance stack: 'log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:HWHDR,mysql1:MYSQL'
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:988 tok=`log2:NFLOG' Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:1025 pushing `NFLOG' on stack Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:988 tok=`base1:BASE' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:1025 pushing `BASE' on stack Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:988 tok=`ifi1:IFINDEX' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025
> pushing `IFINDEX' on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:988
> tok=`ip2bin1:IP2BIN' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025 pushing
> `IP2BIN' on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:988
> tok=`mac2str1:HWHDR' Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025 pushing
> `HWHDR' on stack Mon Feb 26 23:41:31 2024 <1> ulogd.c:988 tok=`mysql1:MYSQL'
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:1025 pushing `MYSQL' on stack Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:802 traversing plugin `MYSQL' Mon Feb 26
> 23:41:31 2024 <5> ../../util/db.c:153 (re)configuring Mon Feb 26 23:41:31
> 2024 <1> ulogd_output_MYSQL.c:129 57 fields in table Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:802 traversing plugin `HWHDR' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:802 traversing plugin `IP2BIN' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:802 traversing plugin `IFINDEX' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:802 traversing plugin `BASE' Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:802 traversing plugin `NFLOG' Mon Feb 26 23:41:31 2024 <1>
> ulogd_inppkt_NFLOG.c:557 parsing config file section `log2', plugin `NFLOG'
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:819 connecting input/output keys of
> stack: Mon Feb 26 23:41:31 2024 <1> ulogd.c:826 traversing plugin `MYSQL'
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `oob.time.sec(?)' as source for
> MYSQL(oob.time.sec) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `oob.time.usec(?)' as source
> for MYSQL(oob.time.usec) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.prefix(?)' as source for MYSQL(oob.prefix) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.mark(?)' as source for MYSQL(oob.mark) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 ifi1(IFINDEX) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.in(?)' as source for MYSQL(oob.in) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 ifi1(IFINDEX) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.out(?)' as source for MYSQL(oob.out) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.family(?)' as source for MYSQL(oob.family) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip.saddr(?)' as source for MYSQL(ip.saddr) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip.daddr(?)' as source for MYSQL(ip.daddr) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip.protocol(?)' as source for MYSQL(ip.protocol) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip.tos(?)' as source for MYSQL(ip.tos) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip.ttl(?)' as source for MYSQL(ip.ttl) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip.totlen(?)' as source for MYSQL(ip.totlen) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip.ihl(?)' as source for MYSQL(ip.ihl) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip.id(?)' as source for MYSQL(ip.id) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip.fragoff(?)' as source for MYSQL(ip.fragoff) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip.csum(?)' as source for MYSQL(ip.csum) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip6.payloadlen(?)' as source for MYSQL(ip6.payloadlen) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `ip6.priority(?)' as source for MYSQL(ip6.priority) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip6.hoplimit(?)' as source for MYSQL(ip6.hoplimit)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `ip6.flowlabel(?)' as source for
> MYSQL(ip6.flowlabel) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `ip6.fragoff(?)' as
> source for MYSQL(ip6.fragoff) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `ip6.fragid(?)' as source for MYSQL(ip6.fragid) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.sport(?)' as source for MYSQL(tcp.sport) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.dport(?)' as source for MYSQL(tcp.dport) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.seq(?)' as source for MYSQL(tcp.seq) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.ackseq(?)' as source for MYSQL(tcp.ackseq) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.window(?)' as source for MYSQL(tcp.window) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.syn(?)' as source for MYSQL(tcp.syn) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.ack(?)' as source for MYSQL(tcp.ack) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.fin(?)' as source for MYSQL(tcp.fin) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.rst(?)' as source for MYSQL(tcp.rst) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.psh(?)' as source for MYSQL(tcp.psh) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.urg(?)' as source for MYSQL(tcp.urg) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.urgp(?)' as source for MYSQL(tcp.urgp) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `tcp.csum(?)' as source for MYSQL(tcp.csum) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `udp.sport(?)' as source for MYSQL(udp.sport) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `udp.dport(?)' as source for MYSQL(udp.dport) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `udp.len(?)' as source for MYSQL(udp.len) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `udp.csum(?)' as source for MYSQL(udp.csum) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `icmp.type(?)' as source for MYSQL(icmp.type) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `icmp.code(?)' as source for MYSQL(icmp.code) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `icmp.echoid(?)' as source for MYSQL(icmp.echoid) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `icmp.echoseq(?)' as source for MYSQL(icmp.echoseq) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `icmp.gateway(?)' as source for MYSQL(icmp.gateway)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `icmp.fragmtu(?)' as source for
> MYSQL(icmp.fragmtu) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `icmp.csum(?)' as source for
> MYSQL(icmp.csum) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `icmpv6.type(?)' as source
> for MYSQL(icmpv6.type) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `icmpv6.code(?)' as
> source for MYSQL(icmpv6.code) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `icmpv6.echoid(?)' as source for MYSQL(icmpv6.echoid) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `icmpv6.echoseq(?)' as source for MYSQL(icmpv6.echoseq) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `icmpv6.csum(?)' as source for MYSQL(icmpv6.csum) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 mac2str1(HWHDR) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `mac.saddr.str(?)' as source for
> MYSQL(mac.saddr.str) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> mac2str1(HWHDR) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `mac.daddr.str(?)' as source for MYSQL(mac.daddr.str) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:783 mac2str1(HWHDR) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `mac.str(?)' as source for MYSQL(mac.str) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 mac2str1(HWHDR) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.protocol(?)' as source for MYSQL(oob.protocol)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:826 traversing plugin `HWHDR' Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `raw.type(?)' as source for HWHDR(raw.type) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.protocol(?)' as source for HWHDR(oob.protocol)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `raw.mac(?)' as source for HWHDR(raw.mac) Mon
> Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:888 assigning `raw.mac_len(?)' as source for HWHDR(raw.mac_len)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31
> 2024 <1> ulogd.c:888 assigning `raw.mac.saddr(?)' as source for
> HWHDR(raw.mac.saddr) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `raw.mac.addrlen(?)' as
> source for HWHDR(raw.mac.addrlen) Mon Feb 26 23:41:31 2024 <1> ulogd.c:826
> traversing plugin `IP2BIN' Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.family(?)' as source for IP2BIN(oob.family) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888
> assigning `oob.protocol(?)' as source for IP2BIN(oob.protocol) Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.saddr(?)' as source for IP2BIN(ip.saddr) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:783 base1(BASE) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `ip.daddr(?)' as source for IP2BIN(ip.daddr) Mon Feb
> 26 23:41:31 2024 <1> ulogd.c:826 traversing plugin `IFINDEX' Mon Feb 26
> 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:888 assigning `oob.ifindex_in(?)' as source for
> IFINDEX(oob.ifindex_in) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783 log2(NFLOG)
> Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `oob.ifindex_out(?)' as
> source for IFINDEX(oob.ifindex_out) Mon Feb 26 23:41:31 2024 <1> ulogd.c:826
> traversing plugin `BASE' Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning `raw.pkt(?)'
> as source for BASE(raw.pkt) Mon Feb 26 23:41:31 2024 <1> ulogd.c:783
> log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `raw.pktlen(?)' as source for BASE(raw.pktlen) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.family(?)' as source for BASE(oob.family) Mon Feb 26 23:41:31 2024 <1>
> ulogd.c:783 log2(NFLOG) Mon Feb 26 23:41:31 2024 <1> ulogd.c:888 assigning
> `oob.protocol(?)' as source for BASE(oob.protocol) Mon Feb 26 23:41:31 2024
> <1> ulogd.c:826 traversing plugin `NFLOG' Mon Feb 26 23:41:31 2024 <1>
> ulogd_inppkt_NFLOG.c:598 opening nfnetlink socket Mon Feb 26 23:41:31 2024
> <1> ulogd_inppkt_NFLOG.c:614 binding to log group 1 Mon Feb 26 23:41:31 2024
> <5> ../../util/db.c:208 starting Mon Feb 26 23:41:31 2024 <1>
> ../../util/db.c:86 allocating 6223 bytes for statement Mon Feb 26 23:41:31
> 2024 <1> ../../util/db.c:138 stmt='SELECT INSERT_PACKET_FULL(' Mon Feb 26
> 23:41:31 2024 <3> ulogd.c:1645 initialization finished, entering main loop
> ulogd.conf ========== [global] user="ulogd" group="ulogd"
> logfile="/var/log/ulogd/ulogd.log" # loglevel: debug(1), info(3), notice(5),
> error(7) or fatal(8) (default 5) loglevel=1
> plugin="/usr/local/lib/ulogd/ulogd_inppkt_NFLOG.so"
> plugin="/usr/local/lib/ulogd/ulogd_filter_IFINDEX.so"
> plugin="/usr/local/lib/ulogd/ulogd_filter_IP2BIN.so"
> plugin="/usr/local/lib/ulogd/ulogd_filter_IP2STR.so"
> plugin="/usr/local/lib/ulogd/ulogd_filter_HWHDR.so"
> plugin="/usr/local/lib/ulogd/ulogd_output_MYSQL.so"
> plugin="/usr/local/lib/ulogd/ulogd_raw2packet_BASE.so"
> plugin="/usr/local/lib/ulogd/ulogd_filter_PRINTPKT.so"
> plugin="/usr/local/lib/ulogd/ulogd_output_LOGEMU.so" # this is a stack for
> logging packet send by system via LOGEMU stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
> # this is a stack for logging packet to MySQL stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:HWHDR,mysql1:MYSQL
> [log1] group=0 [log2] group=1 # Group has to be different from the one use
> in log1 #[log3] #group=2 [emu1] file="/var/log/ulogd/ulogd_syslogemu.log"
> sync=1 [mysql1] db="ulogd" host="localhost" user="ulogd" table="ulog2"
> pass="XXXXXXXX" procedure="INSERT_PACKET_FULL" iptables rules ==============
> Chain LOG_DROP (4 references) pkts bytes target prot opt in out source
> destination 6464 294K DROP tcp -- * * 0.0.0.0/0 0.0.0.0/0 tcp dpts:135:139
> 18631 917K DROP tcp -- * * 0.0.0.0/0 0.0.0.0/0 tcp dpt:445 2379 169K DROP
> udp -- * * 0.0.0.0/0 0.0.0.0/0 udp dpts:135:139 10881 1023K NFLOG all -- * *
> 0.0.0.0/0 0.0.0.0/0 nflog-group 1 nflog-threshold 1 10597 991K NFLOG all --
> * * 0.0.0.0/0 0.0.0.0/0 nflog-threshold 1 115K 11M DROP all -- * * 0.0.0.0/0
> 0.0.0.0/0
> 
> 
