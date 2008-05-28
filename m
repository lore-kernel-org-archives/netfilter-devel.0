From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Wed, 28 May 2008 08:40:03 +0200
Message-ID: <x67idfq6d8@gzp>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>
	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>
	<483C088E.4020405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy <kaber@trash.net>:

| Your types.h doesn't seem to include the endian annotated
| types at all. Does this patch work?

Yes. Next problem:

  CC       libxt_conntrack.oo
In file included from libxt_conntrack.c:21:
../include/linux/netfilter/xt_conntrack.h:38: error: expected specifier-qualifier-list before '__be32'
../include/linux/netfilter/xt_conntrack.h:45: error: expected specifier-qualifier-list before '__be32'
libxt_conntrack.c: In function 'conntrack_parse': libxt_conntrack.c:321: error: 'struct <anonymous>' has no member named 'protonum'
libxt_conntrack.c:323: error: 'struct <anonymous>' has no member named 'protonum'
libxt_conntrack.c:345: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c:365: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c:385: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c:405: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c: In function 'matchinfo_print': libxt_conntrack.c:812: error: 'struct <anonymous>' has no member named 'protonum'
libxt_conntrack.c:821: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c:833: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c:845: error: 'struct <anonymous>' has no member named 'ip'
libxt_conntrack.c:857: error: 'struct <anonymous>' has no member named 'ip'
make[2]: *** [libxt_conntrack.oo] Error 1
make[2]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'
