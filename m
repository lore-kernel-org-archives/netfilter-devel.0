From: Patrick Schaaf <bof@bof.de>
Subject: Re: dhcp-filtering
Date: Thu, 14 Nov 2002 18:03:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021114170317.GA2214@oknodo.bof.de>
References: <Pine.LNX.4.44.0211141238440.773-100000@neon.rooth.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fabian Thorns <fthorns@rooTH.DE>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0211141238440.773-100000@neon.rooth.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Fabian,

> kernel: IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:00:e8:61:b4:26:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=576 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=68 DPT=67 LEN=556
> dhcpd: DHCPREQUEST for 192.168.207.210 (192.168.207.3) from 00:00:e8:61:b4:26 via eth0
[...]
> i thing that it should be possible to filter dhcp-requests and since i
> never heard of some special requirements needed for that propose it looks
> like a bug or misbehavior to me.

The LOG output from iptables clearly shows you that the packets DO pass
the iptables chain, and they WILL be dropped by the DROP policy of the
input chain. Unfortunately, DHCPD appears to be running on a raw socket,
instead of being an ordinary UDP process. raw sockets receive COPIES
of the normally routed packets, and those COPIES to not pass through the
iptables chains, resulting in the behaviour you are seeing.

Whether a DHCPD must run on a raw socket - I don't know. I avoid DHCP
about as hard as I avoid SNMP.

best regards
  Patrick
