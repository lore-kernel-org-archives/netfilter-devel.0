From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] Re: Setting skb->priority with libnetfilter_queue
Date: Mon, 27 Mar 2006 15:38:44 -0600
Message-ID: <44285B64.1000004@info-link.net>
References: <44283F9F.4010206@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44283F9F.4010206@info-link.net>
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

In case anyone is interested, I have written a couple of small patches 
to accomplish what I desired.  It adds three new functions to 
libnetfilter_queue:

   /* Set both mark and priority */
   int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, u_int32_t 
id, u_int32_t verdict, u_int32_t mark, u_int32_t priority,
                               u_int32_t data_len, unsigned char *buf)

   /* Sets priority, but leaves mark unchanged */
   int nfq_set_verdict_priority(struct nfq_q_handle *qh, u_int32_t id, 
u_int32_t verdict, u_int32_t priority,
                               u_int32_t data_len, unsigned char *buf)

   /* Get current skb->priority value */
    u_int32_t nfq_get_priority(struct nfq_data *nfad)

I have performed minimal testing and it appears to work as I had hoped.  
If anyone has any better way to do it, I'm open to suggestions.  I would 
like to see the functionality added to libnetlink_queue at some point, 
but am not hung up on the implementation.  That said, if the netfilter 
developers want to use my patch, feel free.  The libnetfilter_queue 
patch is against current svn (apply with -p0).  The kernel patch is 
against 2.6.16 (with the nfnetlink_queue: fix nfnetlink message size 
patch applied) (apply with -p1).

-Brad


Brad Fisher wrote:
> Does anyone know how I could go about setting the skb->priority for 
> queued packets?  I'd like to have my userspace program be able to 
> classify packets dynamically, but I believe that would require either 
> the skb pointer to the enqueued packet so I could use setsockopt, or a 
> change to the libnetfilter_queue api.  I suppose one could add a 
> function like:
>
>    int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, 
> u_int32_t id, u_int32_t verdict, u_int32_t mark, u_int32_t priority,
>                                u_int32_t data_len, unsigned char *buf)
>
> (or perhaps it  could be called nfq_set_mark_classify?)
>
> Either way, it seems that both the kernel and libnetfilter_queue must 
> be modified.  I'm hoping I'm wrong and that there is a way to do what 
> I want without patching the kernel and libnetfilter_queue.  If so 
> could someone please enlighten me?
>
> -Brad
>
>
> !DSPAM:3824,4428404557196205613798!
>
