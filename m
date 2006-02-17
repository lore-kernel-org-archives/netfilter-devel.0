From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 09:33:46 +0100
Message-ID: <BAY103-F4055BADFA80BE01E71246CB2F80@phx.gbl>
References: <43F4E0AB.5080806@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43F4E0AB.5080806@trash.net>
To: kaber@trash.net
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


Patrick McHardy wrote:

>2.6.16-rc includes patches for proper netfilter IPsec handling.
>Packets will now go through the chains once in plain text and
>once encrypted, so you need to adapt your ruleset. There is a
>new "policy" match, which allows to match on packets from/to
>IPsec tunnels, with that it should be relatively easy to create
>rules for your roadwarriors.

I didn't explain myself. Here is my network schema:

172.23.0.0/23===firenze-gateway..[ipsec 
tunnel]..venezia-gateway===172.16.0.0/23

firenze-gateway is running 2.6.16-rc3-git6, and here is my rules:

Chain INPUT (policy DROP)
target     prot opt source               destination
ACCEPT     all  --  venezia-gateway       0.0.0.0/0
ACCEPT     all  --  127.0.0.1            127.0.0.1
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state 
RELATED,ESTABLISHED
green-me   all  --  172.23.0.0/23        0.0.0.0/0
dmz-me     all  --  85.38.120.0/27       0.0.0.0/0
red-me     all  --  0.0.0.0/0            0.0.0.0/0

Chain red-me (1 references)
target     prot opt source               destination
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           icmp type 3
ACCEPT     esp  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           multiport 
dports 500,4500

Chain FORWARD (policy DROP)
target     prot opt source               destination
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state 
RELATED,ESTABLISHED
ACCEPT     all  --  172.23.0.0/23        172.16.0.0/23
ACCEPT     all  --  172.16.0.0/23        172.23.0.0/23

With these rules I'm able to send/receive packets from the two
private networks each other (172.16.0.0/23<->172.23.0.0/23).
If I delete the first rule in the INPUT table (on firenze-gateway)

ACCEPT     all  --  venezia-gateway       0.0.0.0/0

there is no packet flow inside the tunnel. I don't understand,
as I accept esp packets in the red-me chain.
