From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Usagi IPv6 Conntrack
Date: Wed, 07 Jul 2004 17:11:55 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407070811.RAA09197@toshiba.co.jp>
References: <20040707073141.GJ22729@samad.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: alex@samad.com.au
In-Reply-To: <20040707073141.GJ22729@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Alexander Samad <alex@samad.com.au>
Date: Wed, 7 Jul 2004 17:31:41 +1000

> Hi
> 
> I remember seeing some email before about ipv6 conntracking, is sombody
> looking into bring this across into netfilter or the kernel (sorry not
> sure of the path it would normally take either usagi -> netfilter ->
> kernel or usagi -> kernel).
> 
> Does any one have a set of patches or a procedure to merge in the usagi
> net/ipv6/netfiler stuff.  
> 
> Can I just replace the one in my kernel tree (using a debian base) with
> the usagi directory ?

You can get the latest snapshot of usagi 2.6 kernel and tools which support
ip6_conntrack from

	ftp://ftp.linux-ipv6.org/pub/usagi/snap/kit/

usagi 2.4 kernel does not support ip6_conntrack.

There is kernel configuration about ip6_conntrack in "IPv6: Netfilter
Configuration". If you also want to use IPv6 connection state matching,
you can use ip6tables in usagi-tools. Usage of it is same as IPv4 connection
state matching.

Just for reference, you can get nf_conntrack which generalizes ip_conntrack and
ip6_conntrack from the message from me at 01 Jul 2004 in this ml. This is not
in usagi kernel yet.

Regards,

> 
> Thanks
> Alex

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
