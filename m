From: zhi wang <pangy2004@yahoo.com>
Subject: Fwd: Re: Iptables Source Based Routing
Date: Mon, 19 Apr 2004 06:19:51 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040419131951.20980.qmail@web41702.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I am setting up a linux box roughly working as the one depicted at
> http://lartc.org/howto/lartc.rpdb.multiple-links.html.
> As IPTABLES 1.2.9 has already been installed and it is running on my linux
> box I'm wandering if I can use just Iptables instead of Iproute in order to
> get the required behaviour.
Look at the CONNMARK in pom-ng, it provides a more flexible way to do source
routing. But iproute2 is still a must.
The idea is that you mark the session at input, and use iproute2 to route the
packet with nf-mark, then save the mark at output
 



	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
