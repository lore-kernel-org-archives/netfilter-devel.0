From: Don Mahurin <dmahurin@dma.org>
Subject: New netfilter modules: RELAY, SOURCE, DEST
Date: Fri, 04 Jun 2004 16:33:22 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40C106C2.3050605@dma.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have written some new netfilter/iptables modules that do the following:

RELAY - smart UDP relay, that learns and relays packets from and to the 
endpoint pair that connect to each port in a specified range. The 
source, destination and checksums of relayed packets are adjusted. This 
is useful for servers that act as a middle man in a large number of UDP 
data connections. A /proc interface is implemented to manage ports. The 
/proc interface replaced a netlink interface which remains in the driver.
I have tested the RELAY for about 2000 bi-directional channels with over 
900Mbs of data.

SOURCE - mangles packets changing the source address without the 
overhead and connection tracking associated with NAT.

DEST - mangles packets changing the destination address without the 
overhead and connection tracking associated with NAT.

I have put together the changes in patch-o-matic-ng format, but I am not 
sure where to send that.

http://berkeley.innomedia.com/pub/source/ipt_relay/
http://berkeley.innomedia.com/pub/source/ipt_relay/README.txt
http://berkeley.innomedia.com/pub/source/ipt_relay/linux/patch-o-matic-ng/

Note that currently, the RELAY module requires an allow-spoofing patch, 
as when RELAY is used normally in PREROUTING, it changes the destination 
to the other endpoint and the source to itself. Then the spoofing check 
code sees this as an external packet pretending to be itself.

-don
