From: David Poole <davep@portsmith.com>
Subject: Re: Raw Sockets and Netfiter
Date: 26 Mar 2003 09:13:13 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1048695193.22597.11.camel@athlon>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER>
	 <20030325072544.GI18652@oknodo.bof.de>
	 <20030326153256.GA21953@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030326153256.GA21953@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> PF_PACKET sockets bypass the TCP/IP stack.

Ah.  That makes sense when I finally think about it.

I'm trying to move the DHCP (client currently but eventually server as
well) away from using PF_PACKET to something influenced by iptables
filters.  

Current attempts are using -j QUEUE to receive the packets.  I need to
be able to re-inject a packet to a different destination (from the input
table back out to the output table) back into netfilter.  

I could probably receive through netfilter and send through SOCK_RAW? At
leat that might prevent the flooding problems I'm having.


-- 
David Poole <davep@portsmith.com>
Portsmith   http://www.portsmith.com
960 Broadway Avenue, Suite 300
Boise, ID  83706
208-395-1300 x241
