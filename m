From: Ken-ichi <5ldmountain@tree.odn.ne.jp>
Subject: Re: NAT for IPv6 FINISHED!!!!!
Date: Mon, 01 Nov 2004 22:41:04 +0900
Message-ID: <20041101223953.2274.5LDMOUNTAIN@tree.odn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I found the following message in this ML's past log.
I would like to try to use the code. 
Can I get it even now ?

Regards,
ken-ichi

------------------------------------------------------------------------
NAT for IPv6 FINISHED!!!!!
Natty McButterpants ipv6natlover@yahoo.com
Mon, 24 May 2004 14:19:02 -0700 (PDT)

    * Previous message: conntrack match and locking
    * Next message: NAT for IPv6 FINISHED!!!!!
    * Messages sorted by: [ date ] [ thread ] [ subject ] [ author ]

--0-271857283-1085433542=:67125
Content-Type: text/plain; charset=us-ascii

Gentlemen,
     We have finished the NAT development for IPv6.  It properly translates
ICMPv6, UDP, and TCP packets.  We still need to clean up the code,
perform a few more tests and what not.  We used ping6, traceroute6, and
rlogin along with Ethereal and staring at a lot of tcpdump hex output in
order to test the NAT.  We have not yet ported over support for
application level stuff like TFTP, FTP, etc, but it does not appear to
be too difficult and we may get that out at some point.  Additionally,
we need to compile in DNAT support into the ip6tables user-space tool,
as right now SNAT is all that is compiled in.  The code is rough, but it
works, and as soon as we get it annotated and cleaned up into a tarball,
we'll send it out to whomever wants it.  
 
In response to Jozsef Kadlecsik's question:
>     I hope this work is based on Yasuyuki Kozakai's nf_conntrack
>generalization...
>
>Best regards,
>Jozsef

     Yes, we used USAGI's 2.6.5 kernel with their included connection 
tracking suite to develop and test our NAT.  We only had to make a few
minor modifications.
