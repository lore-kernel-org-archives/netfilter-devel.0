From: "Rajesh B. V." <rajeshbv@intotoinc.com>
Subject: Re: Problem with MASQUERADE of L2TP packets
Date: Mon, 17 Nov 2003 09:52:28 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10>
References: <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
 <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10> <20031115105258.GJ656@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031115105258.GJ656@obroa-skai.de.gnumonks.org>
References: <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
 <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
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

Thankyou very much for the response.

The L2TP implementation is ours. It is not free software or open source.
I tried to trace the code. The observations are,

We call " ip_finish_output () " to send the packet out. Till this function 
call the source IP in outer IP header is intact.
But in this function the POSTROUTING Hook function of IP tables will be 
called. During this the NAT will happen as the masquerade rule is 
configured for POSTROUING.
So i am suspecting iptables handling of L2TP packets.

PS:
I saw some patches for PPTP/IPSec masquerading in net. I guess, it may also 
be similar case for L2TP also, but which was not identified.

Regards,
--Rajesh

At 11:52 AM 11/15/2003 +0100, Harald Welte wrote:
>On Thu, Nov 13, 2003 at 04:32:55PM +0530, Rajesh B. V. wrote:
> > Hi All,
> >
> > We have our L2TP module which now we are integrating with Linux IPtables.
> > We are facing problem in sending data through L2TP session.
>
>Is the source to that module public?  Is it free software?
>
>In that case we could actually have a look at the code and find where
>the issue is.
>
> > PS:
> > Pl. reply me as i did not subscribe to the list.
> >
> > Regards,
> > --Rajesh
>
>--
>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
