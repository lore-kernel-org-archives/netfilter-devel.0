From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:?
Date: Thu, 03 Apr 2003 14:26:12 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304030426.h334QGX15665@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Soporte Meranetwork" <mera@fibertel.com.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Eugen,

  I'm sorry but I'm not the H323 author ... and I haven't used netfilter H323
support since ipchains.  I have CCd the netfilter list in case someone 
there can help.





----- Original Message -----
>From: "Soporte Meranetwork" <mera@fibertel.com.ar>
>To: <Ian.Latter@mq.edu.au>
>Subject:  ?
>Date: Mon, 31 Mar 2003 18:56:17 -0300
>
> Good day.I have used IPTabels 1.2.5-3,and dont know that it have or not H323 modul .But 
for recive Call from outside(internet) to inside(throught NAT) - Netmeeting(ATA 186) i use 
thet rules: 
> $IPTABLES -t nat -A POSTROUTING -o $EXTIF -s 192.168.0.0/24 -j MASQUERADE 
>   (intern LAN)
> PORTFWIP="192.168.0.201" ( PC with Netmeting or ATA 186)
> $IPTABLES -A FORWARD -i $EXTIF -o $INTIF -p tcp --dport 1720 -m state --state
> NEW,ESTABLISHED,RELATED -j ACCEPT
> $IPTABLES -A PREROUTING -t nat -p tcp -d $EXTIP --dport 1720 -j DNAT --to 
$PORTFWIP:1720
> But i want to use NAT without  FORWARD ,PREROUTING with H323 ability for any IP in 
LAN.Where i can find IPtables with ability of H323(version) or where is the patch(modul) for 
that ability? Thank your. 
> Buy,
> Eugen

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
