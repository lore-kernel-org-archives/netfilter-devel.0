From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Newbie looking for help
Date: Tue, 24 Jul 2007 11:52:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241150300.18990@fbirervta.pbzchgretzou.qr>
References: <7a1385300707240242p35064856ic8c1dda871c8aae1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Ron Lee <ronberlin@googlemail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <7a1385300707240242p35064856ic8c1dda871c8aae1@mail.gmail.com>
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


On Jul 24 2007 11:42, Ron Lee wrote:
>
> Hi all,
>
> I am a Master's student working on a small project for policy routing
> of multi-interface network terminals. A part of my project is to
> implement a simple policy module that decides to route outgoing
> packets via different NICs.
>
> I have read the Linux netfilter Hacking HOWTO and have a basic
> understanding of netfilter. But when it comes to coding, I still have
> some doubts. Could someone please give me some hints and/or simple
> code samples that I can study to improve my practical understanding of
> netfilter?

ip ru a fwmark 1337 table 1337
ip r a default via 134.76.13.21 dev eth0 table default
ip r a default via 1.3.3.7 dev eth2 table 1337
iptables -t mangle -A OUTPUT -m random --percentage 0.5 -j MARK --mark 1337


There is zero coding involved.


	Jan
-- 
