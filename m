From: Pablo Neira <pablo@eurodev.net>
Subject: Re: check timer active
Date: Sun, 05 Dec 2004 23:31:35 +0100
Message-ID: <41B38C47.90600@eurodev.net>
References: <EINSTEIN4FR0rmTIVvL000068ca@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	'Henrik Nordstrom' <hno@marasystems.com>,
	'Patrick McHardy' <kaber@trash.net>, 'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEIN4FR0rmTIVvL000068ca@einstein.systemmetrics.com>
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

Richard wrote:

>>Pablo Neira wrote:
>>
>>    
>>
>>>still think that you should use that function.
>>>
>>>Hm, I just realized that the amanda helper is faking counters, I guess
>>>that we need a version of ip_ct_refresh_acct which doesn't the
>>>increase skb counters. I'll send a patch to fix this once I know what
>>>is scheduled with nf_conntrack.
>>>      
>>>
>
>I only saw ip_ct_refresh. What's the difference between ip_ct_refresh_acct
>and it?
>  
>

because you are using a caveman kernel tree :) try with 2.6.10-rc3

--
Pablo
