From: Patrick McHardy <kaber@trash.net>
Subject: Re: check timer active
Date: Sun, 05 Dec 2004 22:31:27 +0100
Message-ID: <41B37E2F.4020007@trash.net>
References: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>	<41B376E9.10607@eurodev.net>
	<41B37BE6.1090208@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	'Henrik Nordstrom' <hno@marasystems.com>,
	'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41B37BE6.1090208@eurodev.net>
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

Pablo Neira wrote:

> still think that you should use that function.
>
> Hm, I just realized that the amanda helper is faking counters, I guess 
> that we need a version of ip_ct_refresh_acct which doesn't the 
> increase skb counters. I'll send a patch to fix this once I know what 
> is scheduled with nf_conntrack.

Feel free to send it now, I still apply bugfixes to ip_conntrack
of course :)

Regards
Patrick
