From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: seeking help on pom and other issues
Date: Mon, 3 May 2004 23:15:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405032306110.17395-100000@filer.marasystems.com>
References: <20040503202400.1496.qmail@web41906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Null Device <nulldevice83@yahoo.com>
In-Reply-To: <20040503202400.1496.qmail@web41906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 3 May 2004, Null Device wrote:

> i tried using pom.
> already have linux source, using 2.4.22-10mdk,
> downloaded iptables and pom-ng.
> 
> when i run ./runme base 
> and when i press y for connlimit
> i get an error
> it states "newfile: 2 files in our way, unable to
> apply"
> i am unable to get this. any help in this regard wud b
> invaluable.

Probably the 2.4.22-10mdk sources you are using already have connlimit
applied..

> Moreover for my modules which i am working on to learn
> netfilter and iptables. userspace program sets the
> parameters for the kernel module to work. in userspace
> code i first bzero a srtuct, fill it with port values
> whic i htons() brfore setting after setting required
> values . when used with ports 20 and 22 it turns the
> values into 5120 and 5632 (all in %d format)
> respective which i am sure are wrong and shuld have
> been sonething like 0020 or 0022. where i am
> slipping??.

Everything is correct. The values in the kernel is network byte order 
(high byte first) while your CPU is little endian (low byte first). See 
ntohs/htons functions.

If you look closely at the numbers you see that 5120 = 20 * 256, adn 5632 
= 22 * 256.

network byte order is what you will see in packet data.

> as i have learned that for skbuff transport header
> (TCP/UDP/ICMP) do not exactly point to transport layer
> headers as supposed to b.

The transport layer pointer is only guaranteed valid within the transport
layer, and then only for the specific transport layer used.

The packet does not neccesarily even have a transport header by the time 
it is processed by netfilter. Consider for example a locally generated 
packet.


See ipt_mac.c for some guidance on how/when to do this kind of thing.

> is it case with ICMP and UDP too?

Yes.

Regards
Henrik
