From: "Davide Guerri" <tato.net@tin.it>
Subject: Re: NAT for IPv6 FINISHED!!!!!
Date: Wed, 26 May 2004 18:25:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006c01c4433e$00fb2970$0400000a@majinbu>
References: <20040524211902.69395.qmail@web90004.mail.scd.yahoo.com> <200405261401.XAA16017@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Yasuyuki,
how do you handle ipv6 fragment? It is possible to know original fragments
size?

BTW, some time ago I have finished my first version of NA(P)T-PT but I wrote
my own connection tracking code (I had expires and I could not wait for an
IPv6 conntrack that could handle fragmentation).

However my connection tracking code isn't that different from yours so, with
minimal effort, I can remove it and use your code when (and if) it will meet
my requirements.

My NA(P)T-PT supports fragmentation (on IPv4 and IPv6 side), preserves the
DF(IPv4) and Fragment Header(IPv6) semantics (it is possible to do path MTU
discovery throught it and it can handle correctly fragments with DF flag
set) and, for now, it works like the masquerade: it's unidiretional, in the
sense that connections may start only from IPv6 side, and IPv4 source
address (for IPv6 to IPv4 translations) is calculated dinamically.
Unfortunately to handle correctly fragments I have had to re-write parts of
kernel fragmentation/defragmentation code, so I'm not that proud of my code
;)

Best regards,
Davide Guerri.

----- Original Message ----- 
From: "Yasuyuki Kozakai" <yasuyuki.kozakai@toshiba.co.jp>
To: <ipv6natlover@yahoo.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, May 26, 2004 4:01 PM
Subject: Re: NAT for IPv6 FINISHED!!!!!

> [...]
> I think your work is useful when someone writes NAT-PT with conntrack
> because we can see how generalization is needed.
> [...]
> I revised nf_conntrack to able to handle fragmented IPv6 packets and
> I'm debugging now. After committing and more testing it, I'll delete
> ip6_conntrack from USAGI tree.
> [...]
> P.S. By the way, what situation do you want to use NAT with IPv6 ?
