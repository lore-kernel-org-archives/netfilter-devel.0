From: Ian Norton <bredroll@darkspace.org.uk>
Subject: Modify an sk_buff from an NF_HOOK
Date: Wed, 2 Mar 2005 01:50:34 +0000
Message-ID: <20050302015034.GA857@earth.dsh.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi everyone,

I've been faffing about for well over two weeks now, and, have come almost to
the conculsion (as I hauntingly suspected) that 'any' changes to an skb that
involve changes outside of the original values of skb->head and skb->tail are 
impossible to do safely. 

say you want to add some bytes to the end of your packet payload, you might
do skb_put(skb,bytes_to_add). you will get a pointer to the old skb->tail
and the new value of skb->tail will be increased accordingly.

this is all well and good, it seems to work, you can see your packet data
without it going crazy, but, then you return your newly changed packet to
netfilter.

and...

you loose everything after the old skb->tail pointer.

I expect this is really going past what netfilter is supposed to do, (after
all, what kind of filter adds stuff?)


-- 
Ian Norton-Badrul
