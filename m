From: Jiri Pirko <jiri@resnulli.us>
Subject: IPV6 nf defrag does not work
Date: Tue, 29 Oct 2013 11:52:08 +0100
Message-ID: <20131029105208.GA18526@minipsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	yoshfuji@linux-ipv6.org, kadlec@blackhole.kfki.hu, kaber@trash.net
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi All.

On the current net-next if you on HOSTA do:
ip6tables -I INPUT -p icmpv6 -j DROP
ip6tables -I INPUT -p icmpv6 -m icmp6 --icmpv6-type 128 -j ACCEPT

and on HOSTB you do:
ping6 HOSTA -s2000    (MTU is 1500)

Only the first ICMP echo request will be passed through, the rest is not
passed on HOSTA. This issue does not occur with smaller packets than MTU (where
fragmentation does not happen).

I'm trying to find out where the problem is.

Any quick ideas?

Thanks

Jiri
