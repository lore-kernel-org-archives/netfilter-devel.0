From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] convert mport to multiport
Date: Mon, 27 Sep 2004 01:36:34 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41575282.4030006@trash.net>
References: <415748E8.60000@eurodev.net> <41574F5E.1020409@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41574F5E.1020409@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Pablo Neira wrote:

> Hi again Patrick,
>
> I think that some comments about the patch could help you to review 
> it, so here we go :-)

Thanks, I appreciate it :)

>> +/* every entry in ports[] except for the last one has one bit in pflags
>> + * associated with it. If this bit is set, the port is the first 
>> port of
>> + * a portrange, with the next entry being the last.
>> + * End of list is marked with pflags bit set and port=65535.
>> + * If 14 ports are used (last one does not have a pflag), the last port
>> + * is repeated to fill the last entry in ports[] */
>> struct ipt_multiport
>> {
>> -    u_int8_t flags;                /* Type of comparison */
>> -    u_int8_t count;                /* Number of ports */
>> +    u_int8_t flags:2;            /* Type of comparison */
>> +    u_int16_t pflags:14;            /* Port flags */
>>     u_int16_t ports[IPT_MULTI_PORTS];    /* Ports */
>> +    u_int8_t count;                         /* Number of ports */
>>  
>>

This breaks userspace compatibility. We can't do that, sorry.

Regards
Patrick
