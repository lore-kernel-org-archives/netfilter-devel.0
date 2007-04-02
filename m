From: "johnpeng" <johnpeng@unitytek.com.tw>
Subject: RE: Multiple calls of check functions
Date: Mon, 2 Apr 2007 20:37:28 +0800
Message-ID: <16501.7015104697$1175517540@news.gmane.org>
References: <4610E8D7.3000701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "'Patrick McHardy'" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4610E8D7.3000701@trash.net>
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

Thanks for the help, and..

> -----Original Message-----
> From: Patrick McHardy [mailto:kaber@trash.net]
> Sent: Monday, April 02, 2007 7:28 PM
> To: johnpeng
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: Multiple calls of check functions
> 
> johnpeng wrote:
> > Dear all:
> >     When I issue the command with debug version of the SAME target (I am
> > using kernel 2.6.17.7 and iptables 1.3.5)
> > "iptables -t nat -A PREROUTING -d 10.10.10.1 -j SAME -to
> > 172.31.0.1-172.31.0.3"
> > I find that the check function of SAME target would be called multiple
> > times, any following SNAT,DNAT rules would call the check function of
the
> > SAME
> > Target ,  however, I didn't see the same situation in kernel 2.4 , is
that
> > due to some framework change in kernel 2.6 ?
> 
> 
> No, that has always been the case. Every rule you add results in an
> entire new ruleset from the kernels POV, so each rule is completely
> validated again.

This means that we need use some flag (in the targetinfo) in the check
function to block the process of some code-flow if we want to the code-flow
to be processed only one time?

> > And
> > When we issue the removal "iptables -t nat -D PREROUTING -d 10.10.10.1
-j
> > SAME -to 172.31.0.1-172.31.0.3",
> > Iptables get reply of "iptables: No chain/target/match by that name",
> >  it seems the memory comparison is not equal with user level and kernel
> > level passed target info data structure,
> > Any solution?
> 
> 
> Unfortunately no, the SAME target is unfixable broken in this regard:
> 
> struct ipt_same_info
> {
>         unsigned char info;
>         u_int32_t rangesize;
>         u_int32_t ipnum;
>         u_int32_t *iparray;
> 
> 
>         /* hangs off end. */
>         struct ip_nat_range range[IPT_SAME_MAX_RANGE];
> };
> 
> The pointer contains random content when dumping the rules from the
> kernel, so we can't compare it. The usual way to deal with this is
> to only compare the first n bytes, but that doesn't work in case
> of SAME since we have data that must be compared following the
> pointer.
> 
> The SAME target is obsolete and SNAT should also uses the same IPs
> for the same source nowadays, so I'd suggest you simply use SNAT.
> 

Because I want to use multiple ranges of SAME, however, multiple range has
been removed from 2.6 ... any solution, thanks!!
