From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: TCPMSS target for IPv6
Date: Mon, 15 Dec 2003 10:26:06 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312150127.KAA00902@toshiba.co.jp>
References: <20031211122649.GA25739@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: nicolas.george@ens.fr
In-Reply-To: <20031211122649.GA25739@clipper.ens.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Nicolas,

From: Nicolas George <nicolas.george@ens.fr>
Date: Thu, 11 Dec 2003 13:26:49 +0100

> I am really missing the TCPMSS target for IPv6. With IPv6, MSS value is
> not only a problem with "criminally braindead ISPs", but also with
> IPv6-over-IPv4 tunnels: if the fragmentation problem arises in the IPv4
> world, an ICMPv4 "fragmentation needed" is sent, but it can not be
> converted into an ICMPv6 "too big", so path MTU discovery does not work.

Please read subsection 3.2. in RFC 2893 .

> As far as I can see, the code for iptables and ip6tables is really
> similar, so it should be quite straightforward to port IPv4 TCPMSS to
> IPv6 for someone that already knows the usual kernel network structures
> (which is, alas, not my case yet).

Do we have any other cases that TCPMSS is needed ? I think MTU issues should be
solved in IPv6 stack (and lower layer in the case that MTU < 1280)
and RFCs say so. So I think we don't need it.

> 
> Regards,
> 
> -- 
>   Nicolas George

----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
