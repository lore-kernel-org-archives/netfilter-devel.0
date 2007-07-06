From: Jordan Russell <jr-list-2007@quo.to>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Fri, 06 Jul 2007 12:42:24 -0500
Message-ID: <468E7F00.5070307@quo.to>
References: <f513uq$kvi$1@sea.gmane.org>	<200706290100.l5T1028w016087@toshiba.co.jp>	<468C15EE.9060806@quo.to>	<200707050111.l651Bu9t008798@toshiba.co.jp>
	<468C86C9.7050204@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Jordan Russell <jr-list-2007@quo.to>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468C86C9.7050204@quo.to>
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

Jordan Russell wrote:
> BTW: does the LOG output indicate that netfilter translated the source
> address of 70.243.226.250 to 192.168.0.133? If so, shouldn't it have
> instead translated the *destination* address of 123.23.23.23 (=eth1) to
> 192.168.0.133? Could this be why the ICMP packet was generated in the
> first place?

To clarify my question:

If tcpdump on eth1 reports:

  70.243.226.250.1703 > 123.23.23.23.25000

while my LOG rule reports for the same packet:

  ... [SRC=192.168.0.133 DST=123.23.23.23 ... SPT=25000 DPT=25000

isn't this saying that netfilter translated the *source* address of the
packet?

Since port 25000 is covered by a DNAT rule:

-A PREROUTING -i eth1 -p tcp -m tcp --dport 25000 -j DNAT
--to-destination 192.168.0.133

shouldn't it have set the *destination* address of the packet to
192.168.0.133, while leaving the source address unchanged?

So: It appears as though netfilter is (in rare cases) translating the
source address of packets when it should be translating the destination
address. Or am I misinterpreting the log output?

-- 
Jordan Russell
