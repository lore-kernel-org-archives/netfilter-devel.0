From: Kishore Dharmavaram <kishored@servgate.com>
Subject: RE: Memory leaks in ip_conntrack?
Date: Mon, 10 Nov 2003 19:07:09 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B2057@skat.sky.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Anthony & All,
Earlier when I checked, /proc/net/ip_conntrack  and /proc/slabinfo were both
showing a number around 34000 to 36000, when I checked again after sometime,
number of connections in /proc/slabinfo hit the maximum 131072 and number of
connections went down to 20 to 30 in /proc/net/ip_conntrack andbox is
rejecting new connections.
Thanks,
Kishore

-----Original Message-----
From: Antony Stone [mailto:Antony@Soft-Solutions.co.uk]
Sent: Monday, November 10, 2003 4:33 PM
To: netfilter@lists.netfilter.org
Subject: Re: Memory leaks in ip_conntrack?


On Tuesday 11 November 2003 12:03 am, Alistair Tonner wrote:

> 	what is set in /proc/sys/net/ipv4/tcp_wmem?
>
> 	I suspect that what is STOPPing the network is there ..
> 	cat /proc/sys/net/ipv4/tcp_wmem -- on my system the max is ...
> 	!! 131072 !!
>
> 	Maybe you've maxed your memory allocation for TCP?

I can understand why you think this might be the magic number causing the 
problem, but why would Kishore be running into this limit with only 20 to 30

connections active on the machine?

> > I believe /proc/slabinfo gives # of conntracks being used, in my tests I
> > usually find slabinfo number is same as number of entries in
> > /proc/net/ip_conntrack. But, after 18hrs or so the number in
> > /proc/slabinfo reaches maximum and box starts refusing connections,
> > /proc/net/ip_conntrack show 20 to 30 entries, I hear
> > /proc/net/ip_conntrack is unreliable and broken. Anyway, I guess I have
> > to dig into the code.

Antony.

-- 

What a waste it is to lose one's mind -- or not to have a mind.   How true 
that is.

 - Dan Quayle, vice-president of the United States of America
                                                     Please reply to the
list;
                                                           please don't CC
me.
