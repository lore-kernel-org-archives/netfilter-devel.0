From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink delete conntrack performance
Date: Mon, 07 Mar 2005 14:13:20 +0100
Message-ID: <422C5370.9050204@trash.net>
References: <422C3A1B.5080604@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <422C3A1B.5080604@ingate.com>
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

Marcus Sundberg wrote:
> When the CTNL_MSG_DELCONNTRACK function of the ctnetlink patch is
> used it calls ip_ct_selective_cleanup() to remove the conntrack.
> 
> This is highly ineffective (depending on how many hash buckets you
> have ofcourse - I had 131007 of them when performing the test :-)
> 
> Is there any reason I'm missing (except that maybe the code should
> go into it's own function) for not simply doing it this way:

You can't drop the reference before calling the timeout function.
BTW: There is no ip_ct_death_by_timeout() AFAICT. Can you send a
new patch ?

Regards
Patrick
