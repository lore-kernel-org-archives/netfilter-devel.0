From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Re: Setting skb->priority with libnetfilter_queue (patch
 really attached this time)
Date: Thu, 06 Apr 2006 13:03:58 +0200
Message-ID: <4434F59E.6060000@trash.net>
References: <44283F9F.4010206@info-link.net> <44285B64.1000004@info-link.net>
	<44285BC2.3020602@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <44285BC2.3020602@info-link.net>
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

Brad Fisher wrote:
> Sorry - I got trigger happy and sent without attaching the patch... 
> Patches should be attached now.
> -Brad
> 
> Brad Fisher wrote:
> 
>> In case anyone is interested, I have written a couple of small patches
>> to accomplish what I desired.  It adds three new functions to
>> libnetfilter_queue:
>>
>>   /* Set both mark and priority */
>>   int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, u_int32_t
>> id, u_int32_t verdict, u_int32_t mark, u_int32_t priority,
>>                               u_int32_t data_len, unsigned char *buf)
>>
>>   /* Sets priority, but leaves mark unchanged */
>>   int nfq_set_verdict_priority(struct nfq_q_handle *qh, u_int32_t id,
>> u_int32_t verdict, u_int32_t priority,
>>                               u_int32_t data_len, unsigned char *buf)
>>
>>   /* Get current skb->priority value */
>>    u_int32_t nfq_get_priority(struct nfq_data *nfad)

I think allowing to set skb->priority makes sense, but I'm not entirely
happy with the 2^n nfq_set_verdict_* combinations. It would be nicer
if we had some struct representing the packet and some functions to
change nfmark, priority etc. Then we could just do
nfq_set_verdict(qh, pkt, verdict).
