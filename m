From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: NAPT with several IP addresses?
Date: Fri, 21 Nov 2003 14:33:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBE05FD.2050704@netlab.hut.fi>
References: <3FBDDCA2.5030307@netlab.hut.fi> <20031121104404.GI29432@sunbeam.de.gnumonks.org>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Sorry, my mistake, you can forget about my comment.
I'm not yet familiar with the whole code and I misunderstood the meaning 
of  IP_NAT_RANGE_PROTO_SPECIFIED.

Thanks,
              Emmanuel


Harald Welte wrote:

>On Fri, Nov 21, 2003 at 11:36:34AM +0200, Emmanuel Guiton wrote:
>  
>
>>Hei!
>>
>>I was looking at the Linux Netfilter Hacking HOWTO and at the source 
>>code in ip_nat_proto_tcp.c and I realized that doing NAPT with several 
>>ports is not supported, am I right?
>>    
>>
>
>of course it is supported.
>
>  
>
>>I mean, in the HOWTO it's written "If IP_NAT_RANGE_PROTO_SPECIFIED isn't 
>>set, it means that the user is doing NAT, not NAPT". Well, we could also 
>>use a range of IP addresses and still perform NAPT, couldn't we? Still 
>>this possibility is not implemented, isn't it?
>>    
>>
>
>I don't really understand what your point.  IP_NAT_RANGE_PROTO_SPECIFIED
>just tells us if the give nat range has only a layer 3 (ip) range, or
>also layer 4 (tcp/udp/...) range.  It doesn't tell you at all if you nat
>to a single address or to multiple addresses.
>
>A nat mapping is internally always represented as a nat range.  Even if
>the range has only the size of one (i.e. a single ip address or port).
>
>  
>
>>           Emmanuel
>>    
>>
>
>  
>
