From: Ben Alabaster <ben@scorpiocc.com>
Subject: iptables modification
Date: Tue, 03 Aug 2004 18:49:36 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1091580576.3949.12.camel@ben1.scorpiocc.corp>
Reply-To: ben@scorpiocc.com
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

I need to modify my iptables module so that it will store FQDN's in the
routing tables but I have no clue where to start.  I will give you an
example of what I'm trying to do to better help explain.

We have (currently) about 150 devices in the field that are assigned
their IP addresses via DHCP from the telephone provider servicing those
devices.  These devices poll our DNS server to update their host record
when their IP address changes so that our DNS server always has their
current IP address.

Also, we have about 80 clients who need to be able to poll these devices
in the field for data.  The software the clients must be preconfigured
with the IP addresses of these devices in the field (meaning that DHCP
is no good to them, they must use static IP) and don't have the ability
to use FQDN's only IP addresses.

Currently my iptables are configured using the following command:

iptables -t nat -A OUTPUT -d <static_ip> -j DNAT --to-destination
<Dynamic_IP>

This is great while the IP address of the remote device doesn't change,
but when it changes, we then have to update the NAT table.

Ideally, I need to be able to do this:

iptables -t nat -A OUTPUT -d <static_ip> -j DNAT --to-destination
<Remote_FQDN>

This will then not resolve the ip address of the remote host until the
packet is being sent out.

I know that I need to modify the command so that I can input an FQDN and
I also need to modify the service so that it will resolve the IP address
when it is actually NAT'ing the packet.

Can you give me some pointers on how I can achieve this please?

Many thanks in advance,

Ben Alabaster
Scorpio Computer & Consulting
