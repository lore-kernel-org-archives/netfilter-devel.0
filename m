From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: NAT for IPv6 FINISHED!!!!!
Date: Wed, 26 May 2004 23:01:42 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405261401.XAA16017@toshiba.co.jp>
References: <20040524211902.69395.qmail@web90004.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ipv6natlover@yahoo.com
In-Reply-To: <20040524211902.69395.qmail@web90004.mail.scd.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


From: Natty McButterpants <ipv6natlover@yahoo.com>
Date: Mon, 24 May 2004 14:19:02 -0700 (PDT)

> Gentlemen,
>      We have finished the NAT development for IPv6.  It properly translates ICMPv6, UDP, and TCP packets.  We still need to clean up the code, perform a few more tests and what not.  We used ping6, traceroute6, and rlogin along with Ethereal and staring at a lot of tcpdump hex output in order to test the NAT.  We have not yet ported over support for application level stuff like TFTP, FTP, etc, but it does not appear to be too difficult and we may get that out at some point.  Additionally, we need to compile in DNAT support into the ip6tables user-space tool, as right now SNAT is all that is compiled in.  The code is rough, but it works, and as soon as we get it annotated and cleaned up into a tarball, we'll send it out to whomever wants it.  


I think your work is useful when someone writes NAT-PT with conntrack
because we can see how generalization is needed.


> In response to Jozsef Kadlecsik's question:
> >     I hope this work is based on Yasuyuki Kozakai's nf_conntrack
> >generalization...
> >
> >Best regards,
> >Jozsef
> 
>      Yes, we used USAGI's 2.6.5 kernel with their included connection tracking suite to develop and test our NAT.  We only had to make a few minor modifications.


I revised nf_conntrack to able to handle fragmented IPv6 packets and
I'm debugging now. After committing and more testing it, I'll delete
ip6_conntrack from USAGI tree.

P.S. By the way, what situation do you want to use NAT with IPv6 ?

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
