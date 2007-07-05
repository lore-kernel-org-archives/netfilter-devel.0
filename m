From: Patrick McHardy <kaber@trash.net>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
	interface?
Date: Thu, 05 Jul 2007 14:21:52 +0200
Message-ID: <468CE260.2040500@trash.net>
References: <468C15EE.9060806@quo.to>	<200707050111.l651Bu9t008798@toshiba.co.jp>	<468C86C9.7050204@quo.to>
	<200707051117.l65BHBA6013655@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <200707051117.l65BHBA6013655@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Yasuyuki KOZAKAI wrote:
> From: Jordan Russell <jr-list-2007@quo.to>
> Date: Thu, 05 Jul 2007 00:51:05 -0500
> 
> 
>>Yasuyuki KOZAKAI wrote:
>>
>>>>Jul  4 14:54:33 webby kernel: [packet out wrong interface] IN= OUT=eth1
>>>>SRC=123.23.23.23 DST=192.168.0.133 LEN=68 TOS=0x00 PREC=0xC0 TTL=64
>>>>ID=39698 PROTO=ICMP TYPE=3 CODE=3 [SRC=192.168.0.133 DST=123.23.23.23
>>>>LEN=40 TOS=0x00 PREC=0x20 TTL=239 ID=39262 PROTO=TCP SPT=25000 DPT=25000
>>>>WINDOW=64172 RES=0x00 RST URGP=0 ]
>>>>
>>BTW: does the LOG output indicate that netfilter translated the source
>>address of 70.243.226.250 to 192.168.0.133? If so, shouldn't it have
>>instead translated the *destination* address of 123.23.23.23 (=eth1) to
>>192.168.0.133? Could this be why the ICMP packet was generated in the
>>first place?

> Hmmm, REJECT in your rule might generate it, but I'm not sure.


Its pretty certain the REJECT target, it defauls to port unreachable
and the network stack doesn't generate port unreachables for TCP.
Jordan, please post your ruleset.

>>>workaround fix is disable hardware checksum offload if you use it.
>>
>>eth1 is running off a 10-year-old 3Com 3C905 adapter, which doesn't
>>appear to support hardware checksums. dmesg says:
>>
>>  0000:01:0c.0: scatter/gather disabled. h/w checksums disabled


I can't find this message in the kernel tree. Which driver are you
using?
