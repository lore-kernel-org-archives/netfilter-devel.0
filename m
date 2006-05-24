From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC,
	NETFILTER]: amanda helper: convert to textsearch infrastructure
Date: Wed, 24 May 2006 12:00:48 +0200
Message-ID: <44742ED0.6010504@trash.net>
References: <446DF48C.5020109@trash.net> <4473A8A8.3040801@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4473A8A8.3040801@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>> I've just converted the amanda helper to the textsearch infrastructure
>> to fix a packet corruption bug. This allows to avoid the data copying
>> and save roughly 64k of memory. The IRC helper looks like a good
>> candidate for this too, FTP is probably quite a bit more complicated.
> 
> 
> It looks fine, just two minor comments. BTW, thanks for doing this: This
> port is on my TODO list since the workshop.
> 
>>  static int __init ip_conntrack_amanda_init(void)
>>  {
>> -    int ret;
>> -
>> -    amanda_buffer = kmalloc(65536, GFP_KERNEL);
>> -    if (!amanda_buffer)
>> -        return -ENOMEM;
>> -
>> -    ret = ip_conntrack_helper_register(&amanda_helper);
>> -    if (ret < 0) {
>> -        kfree(amanda_buffer);
>> -        return ret;
>> +    int ret, i;
>> +
>> +    ret = -ENOMEM;
>> +    for (i = 0; i < ARRAY_SIZE(search); i++) {
>> +        search[i].ts = textsearch_prepare("kmp", search[i].string,
>> +                          search[i].len,
>> +                          GFP_KERNEL, TS_AUTOLOAD);
> 
> 
> I think that the algorithm should be configurable. Although Boyer-Moore
> would not find a matching if the traffic is defragmented (see the header
> of /lib/ts_bm.c), it definitely scales better, so some sysadmins could
> increase performance to the detriment of defragmented traffic:
> 
> http://people.netfilter.org/~pablo/textsearch/


Yes, that really looks better. I guess we could add a module-parameter,
but right now it wouldn't help much because the individual algorithms
can't be configured by the user, they can only be chosen with
"select TEXTSEARCH_...".

> I have an old patch for the FTP helper here somewhere, I could give it
> some spins and send it to you.


Please, I would like to see how complicated it gets. I think what
would really help is something like the fsm algorithm if it would
store the offsets of the individual matches. That would allow to
specify all the possible matches as a single pattern.
