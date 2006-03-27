From: Brad Fisher <brad@info-link.net>
Subject: Setting skb->priority with libnetfilter_queue
Date: Mon, 27 Mar 2006 13:40:15 -0600
Message-ID: <44283F9F.4010206@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Does anyone know how I could go about setting the skb->priority for 
queued packets?  I'd like to have my userspace program be able to 
classify packets dynamically, but I believe that would require either 
the skb pointer to the enqueued packet so I could use setsockopt, or a 
change to the libnetfilter_queue api.  I suppose one could add a 
function like:

    int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, u_int32_t 
id, u_int32_t verdict, u_int32_t mark, u_int32_t priority,
                                u_int32_t data_len, unsigned char *buf)

(or perhaps it  could be called nfq_set_mark_classify?)

Either way, it seems that both the kernel and libnetfilter_queue must be 
modified.  I'm hoping I'm wrong and that there is a way to do what I 
want without patching the kernel and libnetfilter_queue.  If so could 
someone please enlighten me?

-Brad
