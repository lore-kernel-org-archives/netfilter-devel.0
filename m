From: Patrick McHardy <kaber@trash.net>
Subject: Re: Troubeleshooting  a  PPTP conversation
Date: Mon, 28 Aug 2006 11:23:35 +0200
Message-ID: <44F2B617.3000508@trash.net>
References: <925A849792280C4E80C5461017A4B8A206F9CF@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A206F9CF@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
> Hello - 
>  
> I have a firewall with kernel 2.6.17.1 and iptables 1.3.5.  Behind it is
> a Win2000 server with MS RRAS.  I am using ip_nat_pptp and
> ip_conntrack_pptp and trying to setup a PPTP VPN connection from my
> place to this target server. I have appropriate NAT and filtering rules
> set up for tcp 1723 and GRE.  It all works great when I do it the first
> time but began failing for some people after multiple connections or
> connections from different PCs behind the same remote NAT gateway.  Now
> it is behaving badly for me.  I had a PPTP connection from my place to
> the target site last night and then it dropped unexpectedly for some
> reason.  Today I am not able to establish it again.  It's almost as if
> the firewall thinks the old connnection is still alive and it won't get
> rid of a leftover bogus conntrack entry to start a new one.  

What does /proc/net/ip_conntrack show?

> Below is some tcpdump output and I am trying to understand what it is
> telling me:  I did a little bit of formatting to hopefully make it
> readable.  66.173.97.0/27 is my place.  The target site is
> aaa.bbb.212.154.  

What is 10.13.1.22? Please also show your NAT rules and explain
on which side of the firewall your sniffing.

> 18:42:15.012881 IP (tos 0x0, ttl 126, id 54977, offset 0, flags [DF],
> proto: TCP (6), length: 72) 10.13.1.22.1723 > 66.173.97.2.2903
> : P, cksum 0xaf0c (incorrect (-> 0x4d48), 1787486805:1787486837(32) ack
> 1914062599 win 65211: pptp Length=32 CTRL-MSG Magic-Cookie=1
> a2b3c4d CTRL_MSGTYPE=OCRP CALL_ID(999) PEER_CALL_ID(2903)
> RESULT_CODE(1:Connected) ERR_CODE(0:None) CAUSE_CODE(0)
> CONN_SPEED(1480832
> 5) RECV_WIN(16384) PROC_DELAY(0) PHY_CHAN_ID(0)
