From: Pablo Neira <pablo@eurodev.net>
Subject: Re: connection tracking question
Date: Thu, 13 May 2004 00:35:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A2A6BD.9050300@eurodev.net>
References: <6A94CF724B046C4FB3434D14A49A58BF1CB7D3@pluto.rovingplanet.com> <40A2A35B.4010809@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Albert <palbert@rovingplanet.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40A2A35B.4010809@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

ops sorry, error... !:-)

Pablo Neira wrote:

>> Specifically, I would like to know when the ESTABLISHED state is set 
>> in the kernel.
>
>
> mmm, i suppose that you are talking about a tcp connection, 


not necessarily, you could be talking also about conntrack state, yes 
please have a look at:

http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L738

function resolve_normal_ct, see the ct_info var. Don't mix tcp states 
with conntrack states, they are independent.

regards,
Pablo
