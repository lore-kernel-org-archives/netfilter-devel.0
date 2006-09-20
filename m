From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [NETFILTER 11/39]: conntrack: fix race condition in early_drop
Date: Wed, 20 Sep 2006 13:35:18 +0200
Message-ID: <45112776.7000705@drugphish.ch>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
	<20060920082457.14636.39699.sendpatchset@localhost.localdomain>
	<45112555.4040803@drugphish.ch> <45112663.2090500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net, w@1wt.eu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45112663.2090500@trash.net>
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
> Roberto Nibali wrote:
>> Patrick McHardy wrote:
>>
>>> [NETFILTER]: conntrack: fix race condition in early_drop
>>>
>>> On SMP environments the maximum number of conntracks can be overpassed
>>> under heavy stress situations due to an existing race condition.
>>>
>> Candidate for 2.4?
> 
> Not really. We can exceed the limit by a few entries, but its still
> bounded. The same can happen anyway because only entries in the hash
> are counted.

Ok, thanks for your time. We have a similar situation in 2.4 LVS code 
(unpatched for years now) and I was just curious if defects like this 
get addressed in 2.4 kernels nowadays. I reckon so long as noone 
complains, we don't do anything; at least that's how I understood you.

Regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
