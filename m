From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RE : RE : RE : RE : RE : Apply rules to 1 UDP port but port used
 as a socket: possible?
Date: Tue, 17 Feb 2004 11:41:08 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171136510.29541-100000@filer.marasystems.com>
References: <D4EF10CCEB2CE742BEEA9838C590B0E8011CC286@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zze-Proxy GRALL O ext FTRD/SVA/LAN <ograll.ext@rd.francetelecom.com>
In-Reply-To: <D4EF10CCEB2CE742BEEA9838C590B0E8011CC286@ftrdmel2.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> I still need 2 informations:
> -Can I stop the stream ? When I remove the rule (and even Flush) the UDP packets can continue to pass ...

See ctnetlink.

> -Another thing strange is that during my tests I used 2 client programs
> on 2 different machines. They tried to connect to the same server.
> First, for the NAT I apply a rule:
>
>       iptables -t nat -A POSROUTING -p udp -d SERVER_ADDR --dport SERVER_PORT -s CLIENT1_ADDR --sport CLIENT1_PORT -j SNAT --to-source PUBLIC_ADDR:PUBLIC_PORT
>       iptables -t nat -A POSROUTING -p udp -d SERVER_ADDR --dport SERVER_PORT -s CLIENT2_ADDR --sport CLIENT2_PORT -j SNAT --to-source PUBLIC_ADDR:PUBLIC_PORT
>
> So when clients sended UDP packets, only the client who sended the first
> packets was NATed and not the other. I changed the new IP source of the
> 2nd client to "--to-source PUBLIC_ADDR:PUBLIC_PORT2" and then it was OK.

Yes. This is because NAT needs to be able to differentiate the two 
sessions if there is return traffic. The above rules makes the sessions 
after NAT use the exact same addressing information making it impossible 
to determine which session return traffic belongs to. Because of this the 
second NAT session is rejected by netfilter.

Regards
Henrik
