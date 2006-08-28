From: Patrick McHardy <kaber@trash.net>
Subject: Re: Troubeleshooting  a  PPTP conversation
Date: Mon, 28 Aug 2006 17:14:15 +0200
Message-ID: <44F30847.3000607@trash.net>
References: <925A849792280C4E80C5461017A4B8A206F9D9@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A206F9D9@mail733.InfraSupportEtc.com>
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
> Below are all the rules.  NAT table first, then the filter table, then
> the mangle table.  Apologies in advance if the text wrapping gets
> butchered.  There are lots of rules - just search for "1723" and you
> will see the relevant ones.  
> 
> I will try another connection and post /proc/net/ip_conntrack tonight
> when I get back later today.  
> 
> 10.13.1.22 is a Windows 2000 Microsoft RRAS server behind the firewall.
> Win2000 - not Win2003.  I was sniffing the Internet side. Eth0 is the
> Internet side, eth1 is the LAN.  eth2 is a future DMZ but right now is
> empty.
> 
> Here is the big picture:
> 
> My LAN----My Firewall <-Internet-> Lakeville FW --Lakeville LAN and RRAS
> Server
>             66.173.97.0/27     aa.bb.212.154      10.13.1.0/24
> 10.13.1.22
> 
> I have some more data on the problem.  After rebooting both the remote
> and local firewalls, the symptoms stayed the same.  After rebooting the
> Microsoft RRAS server at 10.13.1.22, I was able to get a PPTP connection
> from my place to Lakeville.  After hanging up, I was not able to make
> another connection.  The Microsoft PPTP client keeps redialing.  I went
> off and did other stuff and let it redial - and then between 5 and 10
> minutes later, it connected again.
> 
> 
>>18:42:15.012881 IP (tos 0x0, ttl 126, id 54977, offset 0, flags [DF],
>>proto: TCP (6), length: 72) 10.13.1.22.1723 > 66.173.97.2.2903
>>: P, cksum 0xaf0c (incorrect (-> 0x4d48), 1787486805:1787486837(32) 
>>ack
>>1914062599 win 65211: pptp Length=32 CTRL-MSG Magic-Cookie=1 a2b3c4d 
>>CTRL_MSGTYPE=OCRP CALL_ID(999) PEER_CALL_ID(2903)
>>RESULT_CODE(1:Connected) ERR_CODE(0:None) CAUSE_CODE(0)
>>CONN_SPEED(1480832
>>5) RECV_WIN(16384) PROC_DELAY(0) PHY_CHAN_ID(0)

Well, one noteable thing is that this packet from the PPtP-Server
has an incorrect checksum, and since it also doesn't have its
source address changed the checksum probably already arrived
incorrect on the firewall. The packet is send again two packets
later with the correct address and checksum, but the callids
all look mixed up somehow. What kernel are you using?
