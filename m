From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ctnetlink delete conntrack performance
Date: Tue, 15 Mar 2005 23:47:40 +0100
Message-ID: <4237660C.90602@eurodev.net>
References: <422C3A1B.5080604@ingate.com>
	<422C5370.9050204@trash.net>	<42372984.9090807@ingate.com>
	<4237302B.5040606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Marcus Sundberg <marcus@ingate.com>,
	KOVACS Krisztian <hidden@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4237302B.5040606@trash.net>
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

Patrick McHardy wrote:
>> Also, is there anyone else working on ctnetlink currently, or planning
>> to work on it? Is the goal to get it into the standard kernel, and if
>> so what must be done before that?
> 
> 
> No, we won't try to get it into the kernel. If someone ports it over
> to nf_conntrack we will think about it.

I'm working on porting it to 2.6 following Patrick advices. Now I got 
working fine table dumping. My efforts are currently based on 
ip_conntrack and the conntrack-event-API patch but just to make the 
transition to nf_conntrack easier. I'll be on holidays in one week so 
hope to finish with this soon.

Marcus, could you send me your modification? I'll merge it to my port.

--
Pablo
