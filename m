From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] ipt_recent
Date: Wed, 08 Mar 2006 13:16:27 +0100
Message-ID: <440ECB1B.4070507@trash.net>
References: <dt51lh$b63$1@sea.gmane.org> <43F9EA77.4060208@ufomechanic.net>
	<44096532.2070000@trash.net> <440DAB6B.4020208@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <440DAB6B.4020208@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>>> @@ -20,6 +25,8 @@
>>>     u_int32_t   hit_count;
>>>     u_int8_t    check_set;
>>>     u_int8_t    invert;
>>> +    u_int8_t    check_count;
>>> +    u_int32_t   entry_count;
>>>     char        name[IPT_RECENT_NAME_LEN];
>>>     u_int8_t    side;
>>> };
>>
>>
>>
>> Sorry, we can't do that since it breaks userspace compatibility. But I'm
>> really glad someone finally has the stomach to touch ipt_recent, I'll
>> review your other patches now.
> 
> 
> I've reworked that functionality significantly in a new patch to send
> next week. I will see if I can find a way to make use of existing
> structures to add the functionality.

Otherwise you can you versioning as in ipt_MARK and a couple of other
targets.

> 
> I heard tell that ipt_recent needed a maintainer?

Yes, we need someone familiar with the code to review patches, fix
bugs and clean it up.
