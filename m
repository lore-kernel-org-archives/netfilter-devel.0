From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Mon, 25 Jun 2007 14:52:11 +0200
Message-ID: <467FBA7B.4050100@trash.net>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
	<46713EE8.6060906@trash.net>
	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>
	<46714F7D.4010309@trash.net>
	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>
	<467BDA90.7090802@trash.net>
	<Pine.LNX.4.64.0706231843350.22171@blackhole.kfki.hu>
	<467E844C.6030600@trash.net> <467FB2BE.6080509@trash.net>
	<Pine.LNX.4.64.0706251445390.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706251445390.3137@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
>
> +static const char *hooknames[] = {
> +	[NF_IP_PRE_ROUTING] = "PREROUTING",
> +	[NF_IP_LOCAL_IN] = "INPUT",
> +	[NF_IP_FORWARD] = "FORWARD",
> +	[NF_IP_LOCAL_OUT] = "OUTPUT",
> +	[NF_IP_POST_ROUTING] = "POSTROUTING",
> +};
>
> Align it up.
>   

Yeah, I like that better as well.
>
>   
>> --- a/net/netfilter/Kconfig
>> @@ -343,6 +343,18 @@ config NETFILTER_XT_TARGET_NOTRACK
>>
>> [...]
>>
>> --- a/net/netfilter/Makefile
>> +++ b/net/netfilter/Makefile
>> @@ -44,6 +44,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
>> obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
>> obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
>> obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
>> +obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
>> obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
>> obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
>> obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
>>     
>
> I don't know about your locale, but in mine,
> SECMARK < TCPMSS < TRACE holds.
> (Including CONNSECMARK < SECMARK, but that seems to be another thing.)
>   

They're not strictly alphabetically ordered. TRACE is next to NOTRACK
because they're both raw table targets. In the TRACE case I think it
would make sense to lift that restriction though.

>   
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("ipt_TRACE");
>> +MODULE_ALIAS("ip6t_TRACE");
>>     
>
> No MODULE_AUTHOR/MODULE_DESCRIPTION?
>   

Not required. How really reads those anyway?

>   
>> +static struct xt_target xt_trace_target[] = {
>> +	{
>> +		.name		= "TRACE",
>>     
>                         ^ spaces?
>   

Thanks, will fix.
