From: "Rajesh B. V." <rajeshbv@intotoinc.com>
Subject: Re: Problem with MASQUERADE of L2TP packets
Date: Mon, 17 Nov 2003 15:03:59 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.0.20031117145511.01b3caa0@172.16.1.10>
References: <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10>
 <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
 <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
 <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10> <20031117083821.GB22919@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031117083821.GB22919@sunbeam.de.gnumonks.org>
References: <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10>
 <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
 <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
 <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald Welte,

Thanks for sparing time to reply.

What i observed is, for L2TP packets only the NAT is behaving improper by 
changing the source IP to weired IP (last two octets of PPP IP + last two 
octets of ethernet IP).

Till the IP Tables hook function is called from " ip_finish_output () ", 
the source IP in the IP header is proper and intact.
But after NAT is done and packet is sent out by hook function using " 
ip_finish_output2 () ", the source IP is changed to the weired IP, instead 
of keeping the PPP IP.

That is the only reason i am suspecting IP tables handling of L2TP packets. 
And i want to seek help from like you people to understand if any known 
problem in IP tables masquerading.

Regards,
--Rajesh

At 09:38 AM 11/17/2003 +0100, Harald Welte wrote:
>On Mon, Nov 17, 2003 at 09:52:28AM +0530, Rajesh B. V. wrote:
> > Hi Harald Welte,
> >
> > Thankyou very much for the response.
> >
> > The L2TP implementation is ours. It is not free software or open source.
>
>In this case I have to admit that I am very reluctant to assist you with
>debugging your problem.  I have never been a fan of kernel binary-only
>modules, and I have never given anybody permission to link such modules
>with any netfilter/iptables code that is held by my copyright.
>
> > We call " ip_finish_output () " to send the packet out. Till this function
> > call the source IP in outer IP header is intact.
> > But in this function the POSTROUTING Hook function of IP tables will be
> > called. During this the NAT will happen as the masquerade rule is
> > configured for POSTROUING.
>
>yes. but what is wrong about that?  If you configured masquerading to
>happen, it will happen.
>
> > So i am suspecting iptables handling of L2TP packets.
>
>of course, if you use the IPv4 stack, iptables will act according to the
>configured ruleset.
>
> > PS:
> > I saw some patches for PPTP/IPSec masquerading in net. I guess, it may 
> also
> > be similar case for L2TP also, but which was not identified.
>
>One of the major design ideas behind l2tp was to encapsulate everything
>in UDP - and thus being able to NAT the protocol like any other
>udp-based protocol.  This is very different from AH/ESP or PPTP/GRE that
>come with their own layer 4 protocol.
>
> > Regards,
> > --Rajesh
>--
>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
