From: Masahide NAKAMURA <nakam@linux-ipv6.org>
Subject: Re: [NETFILTER]: ip6_tables: Support MH match.
Date: Tue, 30 Jan 2007 13:23:19 +0900
Message-ID: <45BEC837.2060001@linux-ipv6.org>
References: <200701260953.l0Q9rvv9022736@toshiba.co.jp>	<200701271734.46876@auguste.remlab.net>
	<200701290507.l0T57mwf015698@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: rdenis@simphalempin.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200701290507.l0T57mwf015698@toshiba.co.jp>
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

Hello,

When you reply, can you include my address because I've not subscribed the
netfilter-devel list?

Please find my answer inline.

 > From: Remi Denis-Courmont <rdenis@simphalempin.com>
 > > Date: Sat, 27 Jan 2007 17:34:42 +0200
 > >
 >> > > 	Hello,
 >> > >
 >> > > Le vendredi 26 janvier 2007 11:53, Yasuyuki KOZAKAI a ecrit :
 >>> > > > MH is defined as extention header in RFC3775, but this patch handles
 >>> > > > it as layer 4 protocol header like ICMPv6 header.
 >>> > > >
 >>> > > > The reasons are
 >>> > > > - The reason why it's defined as extentin header is mainly for
 >>> > > >   'piggy back'. But that feature was not specified in RFC3775 after
 >>> > > > all. - No header follow MH. RFC3775 says
 >>> > > > 	Implementations conforming to this specification SHOULD set
 >>> > > > 	the payload protocol type to IPPROTO_NONE (59 decimal).
 >> > >
 >> > > What happens if a node (including a non-Linux one) receives a MH packet
 >> > > with a non-none next protocol? I might be wrong, but I would assume it
 >> > > parses it, at least in some cases.

The node will send ICMP parameter problem back with code depending on
whether the node supports MH or not.
If it supports, the code is 0 (erroneous header field) as RFC3775.
Otherwise, the code 1 (unrecognized Next Header).


 >> > > If this is trye, this patch might introduce a trivial way to evade
 >> > > firewall rules, as firewall admins will assume the next protocol is
 >> > > none, while it might not be.
 >> > >
 >> > > Of course, I could be plain wrong, since I do not know MH.

If the sender creates MH with nexthdr=TCP for example,
it may go through the firewall which is configured even MH=ACCEPT
TCP=DROP. However, the receiver cannot handle it as TCP.

Can I add nexthdr check, or should I rewrite it as "-m" module
to treat MH as an extension header?


 >>> > > > - Many parts in RFCs assume that it's like layer 4 protocol header.
 >>> > > > - Actually Linux IPv6 stack, XFRM, setkey, iproute2... handle it as
 >>> > > > if it's layer4 protocol.
 >> > >
 >> > > Slightly off-topic, but anyway, what about socket() syscall - can you
 >> > > create a IPPROTO_MH raw socket with it?

Yes we can. Actually kernel never originates MH but application
creates MH to send it through the raw socket.


Thanks,


-- 
Masahide NAKAMURA
