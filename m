From: Johan Ankarloo <johan.ankarloo@volvo.com>
Subject: DNAT/SNAT and logging
Date: Tue, 20 Jan 2004 20:15:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074626146.8739.6.camel@ankarloo.got.volvo.net>
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

Hi all. This is a repost. I first tried the
netfilter@lists.netfilter.org list with no luck. Mayby someone here can
help me with an answer to this question?

I need a way to log SNAT/DNAT packets. In the log i need all the
information about what have happend to the packet. Since the log target
is above the actually mangle line, the log target won't know how the
packet will be mangle. What i need in the log files are something like:

Original Source 
Original SourcePort 
Original Destination 
Original DestinationPort
Translated Source 
Translated SourcePort 
Translated Destination 
Translated DestinationPort

As an example, take a look at the documentaion about nat and look at the
examples below taken from
http://www.netfilter.org/documentation/HOWTO//NAT-HOWTO-6.html

---- SNIP ----
## Change destination addresses to 5.6.7.8, 5.6.7.9 or 5.6.7.10.
# iptables -t nat -A PREROUTING -i eth0 -j DNAT --to 5.6.7.8-5.6.7.10
## Change source addresses to 1.2.3.4, 1.2.3.5 or 1.2.3.6
# iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 1.2.3.4-1.2.3.6
---- SNIP ----

Here you can se that you can do DNAT and SNAT to an range of ipadresse
so the question may be a bit clearer when i ask the question like this. 
How is it possible to log to wich ipadress the connection is translated
to? The logs should contain all that the information that is needed to
tell what have happend to a packet.

Regards

Johan
