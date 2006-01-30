From: Carlos Munoz <carlos@kenati.com>
Subject: Do expected related connections apply to FORWARD chain only ?
Date: Mon, 30 Jan 2006 15:37:40 -0800
Message-ID: <43DEA344.6020301@kenati.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

I have written a SIP ALG and and I'm having some problems I hope some of 
you might be able to explain.

The SIP ALG runs on a SOHO firewall/access point. This SOHO product is a 
little unusual since it must support telephones directly connected to it 
and soft phones on the LAN side (intra net). This means there is a VOIP 
application running on it as well as VOIP phones on the LAN.

The ALG works perfect when forwarding SIP messages from the VOIP phones 
on the LAN to the internet. The expected related connection for the RTP 
traffic allows incoming RTP packets.

The problem is with the the VOIP application running on the product 
itself, more specifically the problem is in receiving the incoming RTP 
traffic. If the INPUT policy is ACCEPT, incoming RTP traffic is received 
with no problems. However, if the INPUT policy is set to DROP, incoming 
RTP traffic is not received even though there is an INPUT rule to accept 
all established and related connections. The ALG is setting up the 
expected related connection. Do expected related connections apply only 
to the FORWARD chain ? Why are packets forwarded, but not received by 
the firewall itself ? The FORWARD chain's policy is also DROP. Something 
that I notice is that there is an assure connection with its destination 
and source ports equal to the expected related ports plus one. For 
example if the expected related connection is using ports 5000 and 
29000, connection tracking has an assured connection with ports 5001 and 
29001 even though tcpdump doesn't show any traffic to/from those ports.

Thanks,


Carlos Munoz
