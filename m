From: "Christian Morgenstern" <C.Morgenstern@gmx.de>
Subject: Suggestion regarding masquerading / action when the link goes down
Date: Fri, 6 Jun 2003 19:02:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <005001c32c4d$6e2c3240$7b00a8c0@chr>
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

>From NAT-HOWTO:
You don't need to put in the source address explicitly with masquerading: it
will use the source address of the interface the packet is going out from.
But more importantly, if the link goes down, the connections (which are now
lost anyway) are forgotten, meaning fewer glitches when connection comes
back up with a new IP address.


So if the link goes down for a few seconds, and then comes back up all masq
connections are lost, even though the IP did not change.
Would it be possible to have an additional option for the kernel config, so
the connections aren't cleared if the connection goes down ?
Or even better, how about only clearing the connections if the link comes
back up having a different IP ?

I'm asking this because I've a semi-static IP, and my connection sometimes
drops for a few seconds, usually 3 or 4 times per week. Sometimes the IP
changes, but most times it doesn't. Having the connections cleared means I'd
loose all open connections everytime once I've upraded from ipchains to
netfilter/iptables.

Aside from that I have a related question which I haven't found in the
FAQ/HowTos:
Is the conntrack table also being cleared if the link goes down/comes back
up ?

-- Christian
