From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] don't try to track broadcasts or multicasts (4/4)
Date: Sun, 9 Jun 2002 21:35:06 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206092135.06199@henrik.marasystems.com>
References: <1023366027.845.30.camel@tux> <1023547908.19838.46.camel@tux> <20020609171826.GD3181@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <20020609171826.GD3181@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 09 June 2002 19:18, Harald Welte wrote:

> the results are actually quite interesting - but maybe there's a
> particular reason for TCP behaving different than other
> protocols...

Broadcast or multicast does not apply to TCP. It does in the other 
protocols (ICMP / UDP). A broadcast or multicast packet received by 
TCP is with no doubt a martian as there is no aspect of TCP that can 
be safely used on other than unicast links.

Linux ICMP seems to have some provision to filter out broadcasts when 
they do not make sense, but it could do better I think..

But I think this aspect of the Linux IP stack can be ignored local 
traffic. If you receive a broadcast frame addressed to your unicast 
IP address then the processing should not be much different from 
receiving a broadcast frame addressed to your broadcast address. The 
likelyhood that there is TCP/IP implementations sending you broadcast 
link frames when unicast was intended is very low.

But the reverse cannot be assumed. There is special applications of 
TCP/IP where multicast is used as local transport. This can be seen 
in some odd active-active load balancing products where all servers 
must see all packets, so a Linux server/router can be required to 
receive unicast IP frames from a multicast link source address or to 
sent unicast IP to a multicast link address..

If this is considered in a bridge environment using the 
bridge-netfilter integration then obviously no optimization based on 
unicast/multicast link transport can be done on forwarded packets..

Regards
Henrik
