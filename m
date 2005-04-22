From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP Connection tracking and SYN/ACK/PSH
Date: Fri, 22 Apr 2005 15:45:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504221529520.28541@blackhole.kfki.hu>
References: <20050417193718.6a7f0809.gniibe@fsij.org>
	<Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
	<4265B0B7.5090707@variosecure.net>
	<Pine.LNX.4.61.0504200842001.22001@filer.marasystems.com>
	<4268C5FB.5040201@variosecure.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ukai@debian.or.jp, netfilter-devel@lists.netfilter.org,
	NIIBE Yutaka <gniibe@fsij.org>, Henrik Nordstrom <hno@marasystems.com>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tim Burress <tim@variosecure.net>
In-Reply-To: <4268C5FB.5040201@variosecure.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Fri, 22 Apr 2005, Tim Burress wrote:

> I think the segments are invalid (or at least in-something), but I agree
> with your second point. Since PSH has no bearing on TCP connection
> state, it seems like it might be better to treat PSH the same way as ECE
> and CWR, and have conntrack ignore it. Other layers could then decide
> whether to accept or drop combinations like SYN+ACK+PSH depending on how
> strictly they want to enforce protocol conventions in the firewall. It's
> not so much a question of whether the segments are valid or not as
> whether strict protocol enforcement (beyond what is needed for
> connection tracking) is really conntrack's job. And since I didn't
> design it, I'm not sure!

The sole task of conntrack is to keep track of the connections :-),
however it may flag packets as invalid (or even drop directly) in order to
preserve its sanity. It should not protect the communicating parties from
sending illegal packets, as far as the packets can be tracked. Such
protection should be configured in the raw/filter tables.

Patrick, could you submit NIIBE Yutaka's patch, which started this thread?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
