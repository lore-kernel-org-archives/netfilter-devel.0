From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2.6] Use C99 initializers for conntrack sysctl tables
Date: Mon, 23 Feb 2004 00:45:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40393F00.8040805@eurodev.net>
References: <20040220210758.GV4797@sunbeam.de.gnumonks.org> <20040220151242.78536970.davem@redhat.com> <4036D735.E834F74A@actiontec.com> <40393E1E.5050807@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bo Xiong <bxiong@actiontec.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <40393E1E.5050807@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Bo Xiong wrote:
>
>> init_conntrack()  will creat a new conntrack, bu where add the new
>> conntrack to hash_list?
>> -Bo
>>
>>  
>>
> Hi Bo,
>
> why didn't you create a new thread? the topic of this message is 
> different.
>
> anyway, have a look at:
>
> http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L460
>
> init_conntrack creates a new conntrack and insert it to the hash list 
> as well (see list_prepend).

Sorry!! this is wrong, init_conntrack only creates the conntrack, it is 
inserted in __ip_conntrack_confirm, see the link above. A little 
blackout :-(

Pablo
