From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT (fwd)
Date: Thu, 23 Feb 2017 08:12:02 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702230810080.2203@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:27232
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750891AbdBWHMG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 02:12:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

It looks like the switch starting on line 106 should be indented more if
it is expected to be under the if in line 105.  I believe that there
should also be braces around the switch.  It is a single statement, but it
is a complex one.

thanks,
julia

---------- Forwarded message ----------
Date: Thu, 23 Feb 2017 12:43:05 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT

CC: kbuild-all@01.org
In-Reply-To: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>

Hi Richard,

[auto build test WARNING on v4.9-rc8]
[cannot apply to nf-next/master next-20170222]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Richard-Guy-Briggs/audit-normalize-NETFILTER_PKT/20170223-110223
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> net/netfilter/xt_AUDIT.c:106:1-2: code aligned with following code on line 116

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 8f27486f1987d344c4d9b0de556dfd4209c524bf
vim +106 net/netfilter/xt_AUDIT.c

8f27486f Richard Guy Briggs 2017-02-22  100  				audit_ip6(ab, skb, &apar);
43f393ca Thomas Graf        2011-01-16  101  				break;
43f393ca Thomas Graf        2011-01-16  102  			}
43f393ca Thomas Graf        2011-01-16  103  		}
43f393ca Thomas Graf        2011-01-16  104  	}
8f27486f Richard Guy Briggs 2017-02-22  105  	if (apar.ipv == -1)
43f393ca Thomas Graf        2011-01-16 @106  	switch (par->family) {
43f393ca Thomas Graf        2011-01-16  107  	case NFPROTO_IPV4:
8f27486f Richard Guy Briggs 2017-02-22  108  		audit_ip4(ab, skb, &apar);
43f393ca Thomas Graf        2011-01-16  109  		break;
43f393ca Thomas Graf        2011-01-16  110
43f393ca Thomas Graf        2011-01-16  111  	case NFPROTO_IPV6:
8f27486f Richard Guy Briggs 2017-02-22  112  		audit_ip6(ab, skb, &apar);
43f393ca Thomas Graf        2011-01-16  113  		break;
43f393ca Thomas Graf        2011-01-16  114  	}
43f393ca Thomas Graf        2011-01-16  115
8f27486f Richard Guy Briggs 2017-02-22 @116  	switch (apar.ipv) {
8f27486f Richard Guy Briggs 2017-02-22  117  	case 4:
8f27486f Richard Guy Briggs 2017-02-22  118  		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
8f27486f Richard Guy Briggs 2017-02-22  119  			 apar.saddr, apar.daddr, apar.proto);

:::::: The code at line 106 was first introduced by commit
:::::: 43f393caec0362abe03c72799d3f342af3973070 netfilter: audit target to record accepted/dropped packets

:::::: TO: Thomas Graf <tgraf@infradead.org>
:::::: CC: Patrick McHardy <kaber@trash.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
