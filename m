From: "Jeremy Elson" <jelson@gmail.com>
Subject: Per-client NAT routing -- possible?
Date: Wed, 22 Mar 2006 09:16:41 -0800
Message-ID: <51e5f6120603220916v3c536afamdb3023563866397d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

I'm trying to set up a Linux box as a NATting router.  But here's the
trick: my box's external interface is on a LAN that has a whole bunch
of routers on it, any of which can be used to access the Internet.=20
I'm trying to figure out how to configure iptables so that the NAT box
selects the router to use based on client IP address (i.e., the IP
address on the inside interface).

I've been tinkering with a command like this:

iptables -t nat -A POSTROUTING -i $INTERNAL_CLIENT_IP -o
external-iface0 -j SNAT --to $EXTERNAL_ROUTER_IP

...but it seems that --to controls the new source address given to the
packet (i.e., the router's outside-interface IP), and not the
destination to which the NATted packet is sent.

Could someone please point me in the right direction?  Or is this not possi=
ble?

Thanks!

--Jeremy
