From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Cleanup ctstat
Date: Sun, 19 Sep 2004 22:34:47 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414DED67.7050001@trash.net>
References: <1095597683.8380.10.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1095597683.8380.10.camel@tux.rsn.bth.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:

>Hi Patrick
>
>Here's the first of two patches based on Pablo Neiras patch.
>
>This patch simply adds a macro to increase the statistics.
>And it changes icmp_error to error in struct ip_conntrack_stat in order
>to adopt to the tcp-windowtracking changes.
>
>Please submit for 2.6
>  
>

I've added it to my tree I'm about to submit.

Regards
Patrick
