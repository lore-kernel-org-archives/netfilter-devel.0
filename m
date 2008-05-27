From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Tue, 27 May 2008 14:10:44 +0200
Message-ID: <x6y75w3q2j@gzp>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>
	<483BB9DE.6050003@trash.net>
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

| Thanks for the report. Does this patch fix it?

Not really.

  CC       libxt_connlimit.oo
In file included from /usr/include/linux/netfilter_ipv4.h:9,
                 from ../include/linux/netfilter_ipv4/ip_tables.h:19,
                 from ../include/libiptc/libiptc.h:7,
                 from ../include/iptables.h:5,
                 from libxt_connlimit.c:8:
../include/linux/netfilter.h:42: error: expected specifier-qualifier-list before '__be32'
make[2]: *** [libxt_connlimit.oo] Error 1
make[2]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'
make[1]: *** [all-recursive] Error 1
