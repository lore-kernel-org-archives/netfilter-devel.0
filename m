From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH nf-next v2 03/10] netfilter: ebt_log: add net namespace
 support for ebt_log
Date: Mon, 08 Apr 2013 10:50:04 +0800
Message-ID: <5162305C.7050000@cn.fujitsu.com>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com> <1364205048-32632-3-git-send-email-gaofeng@cn.fujitsu.com> <20130405183243.GC4853@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56302 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934650Ab3DHCtP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:49:15 -0400
In-Reply-To: <20130405183243.GC4853@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013/04/06 02:32, Pablo Neira Ayuso wrote:
> On Mon, Mar 25, 2013 at 05:50:41PM +0800, Gao feng wrote:
>> Add pernet_operations for ebt_log, in pernet_ops,
>> we call nf_log_set/unset to set/unset nf_loggers
>> of per net.
>>
>> Because the syslog ns has not been implemented,
>> we don't want the container DDOS the host's syslog.
>> so only enable ebt_log in init_net and wait for
>> syslog ns.
> 
> Applied with change.
> 
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  net/bridge/netfilter/ebt_log.c | 24 +++++++++++++++++++++++-
>>  1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
>> index 08e5ea5..cd465d1 100644
>> --- a/net/bridge/netfilter/ebt_log.c
>> +++ b/net/bridge/netfilter/ebt_log.c
>> @@ -78,6 +78,10 @@ ebt_log_packet(u_int8_t pf, unsigned int hooknum,
>>     const char *prefix)
>>  {
>>  	unsigned int bitmask;
>> +	struct net *net = dev_net(in ? in : out);
>> +
> 
> Added a comment here to explicitly recall that we depend on syslog ns
> support to remove these two lines below.
> 

This is good, and I will note this too.

>> +	if (!net_eq(net, &init_net))
>> +		return;
>>  
>>  	spin_lock_bh(&ebt_log_lock);
>>  	printk(KERN_SOH "%c%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
>> @@ -207,6 +211,22 @@ static struct nf_logger ebt_log_logger __read_mostly = {
>>  	.me		= THIS_MODULE,
>>  };
>>  
>> +static int __net_init ebt_log_net_init(struct net *net)
>> +{
>> +	nf_log_set(net, NFPROTO_BRIDGE, &ebt_log_logger);
>> +	return 0;
>> +}
>> +
>> +static void __net_exit ebt_log_net_fini(struct net *net)
>> +{
>> +	nf_log_unset(net, &ebt_log_logger);
>> +}
>> +
>> +static struct pernet_operations ebt_log_net_ops = {
>> +	.init = ebt_log_net_init,
>> +	.exit = ebt_log_net_fini,
>> +};
>> +
>>  static int __init ebt_log_init(void)
>>  {
>>  	int ret;
>> @@ -214,12 +234,14 @@ static int __init ebt_log_init(void)
>>  	ret = xt_register_target(&ebt_log_tg_reg);
>>  	if (ret < 0)
>>  		return ret;
>> +
>>  	nf_log_register(NFPROTO_BRIDGE, &ebt_log_logger);
>> -	return 0;
>> +	return register_pernet_subsys(&ebt_log_net_ops);
> 
> You have to unroll in case register_pernet_subsys, I fixed this.
> 

This is my mistake,thanks for your fix :)

