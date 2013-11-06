From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [patch net-next 2/3] netfilter: ip6_tables: use reasm skb for
 matching
Date: Wed, 06 Nov 2013 08:12:14 -0800
Message-ID: <1383754334.4291.174.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1383649333-6321-1-git-send-email-jiri@resnulli.us>
	 <1383649333-6321-3-git-send-email-jiri@resnulli.us>
	 <20131105133205.GC15370@breakpoint.cc>
	 <20131105134118.GA5818@macbook.localnet>
	 <20131105150115.GB2438@minipsycho.orion>
	 <20131105181633.GA7435@macbook.localnet>
	 <20131106141845.GC2458@minipsycho.orion>
	 <20131106143349.GF15370@breakpoint.cc>
	 <20131106144453.GD2458@minipsycho.orion>
	 <20131106145104.GA18406@macbook.localnet>
	 <20131106152907.GE2458@minipsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, yoshfuji@linux-ipv6.org,
	kadlec@blackhole.kfki.hu, mleitner@redhat.com,
	kuznet@ms2.inr.ac.ru, jmorris@namei.org, wensong@linux-vs.org,
	horms@verge.net.au, ja@ssi.bg, edumazet@google.com,
	pshelar@nicira.com, jasowang@redhat.com,
	alexander.h.duyck@intel.com, coreteam@netfilter.org
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20131106152907.GE2458@minipsycho.orion>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2013-11-06 at 16:29 +0100, Jiri Pirko wrote:

> I'm working on it atm.

Note that we have a similar problem in general with GRO and forwading.

We do no check against output mtu, if the packet is GSO.

skb_is_gso() being true bypasses the safety checks.
