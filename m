From: "allug4me allug4me" <allug4me@gmail.com>
Subject: Re: SIP ALG - Marking TOS/DSCP
Date: Thu, 12 Apr 2007 20:57:55 +0530
Message-ID: <ceaf8eaa0704120827n74e3511ar8e7d85b0367f9b2f@mail.gmail.com>
References: <ceaf8eaa0704102342j5df5a98clc32a7d99c4cb8329@mail.gmail.com>
	<461C90F5.80905@trash.net>
	<ceaf8eaa0704120826w25b2c28cma466c782bb7c764d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <ceaf8eaa0704120826w25b2c28cma466c782bb7c764d@mail.gmail.com>
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

Thank you very much Patrick for your help.

Using the commands you provided i was able to mark SIP packets.
But for RTP, the marking isn't done. I am not sure about the problem.

Is there any way to enable debug messages for sip helper so that it
can provide some insight?

Thanks for your help.
marc



On 4/11/07, Patrick McHardy <kaber@trash.net> wrote:
> allug4me allug4me wrote:
> > I am developing a module for a linux router. All the packets from LAN
> > to WAN are natted. I am using linux 2.6.18.2 kernel. Hence for SIP/RTP
> > packets from LAN to pass through I am using SIP Protocol Support of
> > Netfilter by enabling CONFIG_IP_NF_SIP as module.
> >
> > The module I am developing needs to  mark the SIP, RTP and RTCP
> > packets with TOS/DSCP in IP Header and COS in the VLAN header.
> >
> > Can anyone please help me to achieve this task?
>
>
> iptables doesn't support VLAN header mangling since its usually not
> present, with the exception of bridged packets. DSCP marking of
> SIP/RTP is quite simple and should be possible without a new module:
>
>
> # SIP
> iptables -t mangle -A POSTROUTING -p udp --dport 5060 -j DSCP --set-dscp ...
>
> # RTP
> iptables -t mangle -A POSTROUTING -m helper --helper sip -j DSCP
> --set-dscp ...
>
>
> RTCP is currently not recognized by the SIP helper, although it should
> be trivial to add. If you do so please consider sending us the patch.
>
