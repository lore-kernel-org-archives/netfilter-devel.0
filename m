From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Fri, 11 Mar 2005 06:14:17 +0100
Message-ID: <42312929.7000102@trash.net>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>	
	<42307E2A.5060806@trash.net>
	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>	
	<42308509.4040902@trash.net>
	<01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>	
	<42308B4E.3030303@trash.net>
	<1110483093.1100.9.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1110483093.1100.9.camel@tux.rsn.bth.se>
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

Martin Josefsson wrote:
> On Thu, 2005-03-10 at 19:00 +0100, Patrick McHardy wrote:
> 
> 
>>>but it doesn't work yet...
>>>
>>>what I am doing wrong ?
>>
>>Check if the rules are used and what happens on the network ..
> 
> 
> I belive the problem is in ip_route_output_slow() line 2070 in
> ipv4/ip_output.c in 2.6.11.2
> 
> make_route:
>         if (LOOPBACK(fl.fl4_src) && !(dev_out->flags&IFF_LOOPBACK))
>                 goto e_inval;
> 
> It simply does not route packets with loopback addresses out via non
> loopback interfaces, and SNAT occurs at POSTROUTING...
> Not sure what a good solution could be, we certainly don't want to the
> possibility to send out packets with 127.0.0.1 as source (like some
> windows virus got the windows stack to do by synflooding a domain that
> later got changed into 127.0.0.1)

Maybe we can use 0 as source if LOOPBACK(src). OTOH, I don't think we
want to route packet with loopback source, so we may instead declare
this as a bad testcase :)

Regards
Patrick
