From: Ulysses Almeida <munky@maluco.com.br>
Subject: Re: libipq/payload doubt
Date: Wed, 19 May 2004 20:03:06 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040520000305.GA2227@maluco.com.br>
References: <20040519062032.GA32401@maluco.com.br> <1084960972.40ab30cc0af1c@chloride.lan.uchange.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <1084960972.40ab30cc0af1c@chloride.lan.uchange.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  Thanks, all, I just tried with htons(), and every thing works fine.

  Now I another doubt. I alredy read ip_queue.c, and alredy understood,
that payload is skb->data.

 ---
  memcpy(pmsg->payload, entry->skb->data, data_len);
 ---

  But, skb->data isn't clear enough on my head. If I queue every packge,
can I know which type is it? (TCP/UDP/ICMP), just looking for payload?
  Packet data, can be analyzed on userspace, or maybe changed?

  How can i get a payload X-ray?

  When i tried something like printf ("%d\n", tcph->syn); i started to
recive "passer: Received message truncated: No such file or directory"
from my program. What is it means?

  The last question, probably I can easily find on google, but the
other ones, I can't find that easy

  I think that's it for today! (One day I'll be able to answer
begginers question, yes I will, I belive in that! ;))


On Wed, May 19, 2004 at 11:02:52AM +0100, Richard Bishop wrote:
> 
> As one of the other guys said, the port discrepancy is an 'endian' problem.
> 
> Try this code (attached) - I had exactly the same problem when I first started
> playing around with ipq.  Bear in mind that I've skipped out all of the code for
> setting up the ipq handle etc, though if you've had it recieving packets then
> you'll have this already.
> 
> Good luck!
> 
> 
> Richard
> 

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
