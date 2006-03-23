From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: conntrack and IKE confused on 2.6.16
Date: Thu, 23 Mar 2006 10:16:07 +0100
Message-ID: <BAY103-F8424E12312A9CDFE2D9BCB2DE0@phx.gbl>
References: <44218D97.6000002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44218D97.6000002@trash.net>
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

>Marco Berizzi wrote:
> > Patrick McHardy wrote:
> >
> >> I'm not sure I understand you correctly. The notebook users
> >> establishes a VPN to the remote side.
> >
> >
> > Yes.
> >
> >> Why shouldn't the
> >> IKE-traffic be directed back to him?
> >
> >
> > lnx and lnx2.6.16 must talk each other to
> > establish/renew the ike/ipsec sa, but lnx2.6.16
> > is directing packets for itself to the notebook.
> > Is this clear?
>
>Not exactly. Is the tunnel between the notebook user and
>the remote gateway, between the two gateways or both?

My apologies, I didn't explain myself.
There is a tunnel between the two private networks
implemented by the two linux system lnx & lnx2.6.16:
this tunnel delivery traffic from network priv-net-fi
to priv-net-venezia and viceversa. The two endpoints
ip addresses are pub-ip-fi for priv-net-fi and
pub-ip-ve for priv-net-venezia. This is the "GOOD" &
working 24x7 tunnel.

priv-net-fi--|lnx|--pub-ip-fi**internet**pub-ip-ve--|lnx2.6.16|--priv-net-venezia
             +---------------GOOD ipsec tunnel----------------+

Users notebook (roadwarriors) are configured that they
can connect to priv-net-fi and priv-net-venezia from
the internet via IPsec. So I specified this
configuration for every notebook:

network to reach: priv-net-venezia
ipsec remote endpoint: pub-ip-ve
ipsec me endpoint: any_ip_address

network to reach: priv-net-fi
ipsec remote endpoint: pub-ip-fi
ipsec me endpoint: any_ip_address

Users connect to the internet, gain a dynamic ip
address, double click the ipsec icon on the desktop
and the notebook establish two ipsec tunnel:

any_ip_address--**internet**pub-ip-ve--|lnx2.6.16|--priv-net-venezia
any_ip_address--**internet**pub-ip-fi--|lnx|--priv-net-fi

This is the good story. Now I will try to explain
what has been happened tuesday. Our roadwarrior
user has connected his notebook to priv-net-venezia
and he didn't know that exists the "GOOD" tunnel
and he double clicked the ipsec icon, so his notebook
has tried to establish the ipsec tunnel to priv-net-fi
This the diagram:

notebook(172.16.1.227)--|lnx2.6.16 snat to 
pub-ip-ve|--**internet**pub-ip-fi--|lnx|--priv-net-fi

The notebook has taken an ip address from the
priv-net-venezia subnet (172.16.1.227).

1) IKE's notebook daemon send a packet to pub-ip-fi:
src=172.16.1.227 sport=500 dst=pub-ip-fi dport=500
2) our firewall, lnx2.6.16 (which is also the ipsec
endpoint for the "GOOD" tunnel) snat the IKE packet
from the notebook with pub-ip-ve address (which is also
the same ipsec endpoint address for the "GOOD" tunnel):
src=pub-ip-ve sport=500 dst=pub-ip-fi dport=500
3) lnx2.6.16 put this entry in proc/net/ip_conntrack:
udp      17 169 src=172.16.1.227 dst=pub-ip-fi sport=500
dport=500 packets=51 bytes=9264 src=pub-ip-fi
dst=pub-ip-ve sport=500 dport=500  packets=77 bytes=29760
[ASSURED] mark=0 use=1
4) lnx (ipsec gateway) receive the IKE packet. It comes
from pub-ip-ve. IKE daemon on lnx doesn't like that
packet because the id is wrong: it expect the id from
the lnx2.6.16 ipsec gateway not that from the notebook,
it will drop it.
5) lnx need to renegotiate the "GOOD" tunnel so
it send an IKE packet to pub-ip-ve
6) lnx2.6.16 receive the IKE packet which is for itself
but it forwards to the evil notebook.
7) after a while the "GOOD" tunnel goes down...
