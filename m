From: Patrick McHardy <kaber@trash.net>
Subject: Re: SIP ALG - Marking TOS/DSCP
Date: Wed, 11 Apr 2007 09:40:37 +0200
Message-ID: <461C90F5.80905@trash.net>
References: <ceaf8eaa0704102342j5df5a98clc32a7d99c4cb8329@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: allug4me allug4me <allug4me@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <ceaf8eaa0704102342j5df5a98clc32a7d99c4cb8329@mail.gmail.com>
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

allug4me allug4me wrote:
> I am developing a module for a linux router. All the packets from LAN
> to WAN are natted. I am using linux 2.6.18.2 kernel. Hence for SIP/RTP
> packets from LAN to pass through I am using SIP Protocol Support of
> Netfilter by enabling CONFIG_IP_NF_SIP as module.
> 
> The module I am developing needs to  mark the SIP, RTP and RTCP
> packets with TOS/DSCP in IP Header and COS in the VLAN header.
> 
> Can anyone please help me to achieve this task?


iptables doesn't support VLAN header mangling since its usually not
present, with the exception of bridged packets. DSCP marking of
SIP/RTP is quite simple and should be possible without a new module:


# SIP
iptables -t mangle -A POSTROUTING -p udp --dport 5060 -j DSCP --set-dscp ...

# RTP
iptables -t mangle -A POSTROUTING -m helper --helper sip -j DSCP
--set-dscp ...


RTCP is currently not recognized by the SIP helper, although it should
be trivial to add. If you do so please consider sending us the patch.
