From: Rommy Taslim <rommyt@transportservices.com.au>
Subject: Forward UDP broadcast
Date: 03 Jun 2003 14:48:37 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054615717.23000.34.camel@hyperno.canodesc.com>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi,

Anyone knows how to forward UDP broadcast using iptables ?
I need to do something like ipportfw does:
ipportfw -A -u 192.168.4.255/699 -R 192.168.2.255/699

which forward all the broadcast on network 4 for port 699 to network 2.

I have something like this for iptables:

iptables -t nat -A PREROUTING -p udp \
	-d 192.168.4.255 --dport 699 \
	--to-destination 192.168.2.255:699

But it didn't work.

Anyone can give me some pointers ??

Thanks in advance.

Rommy
