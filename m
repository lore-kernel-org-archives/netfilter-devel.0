From: Ian Norton <bredroll@darkspace.org.uk>
Subject: Re: using netfilter hooks (in not the intended way)
Date: Fri, 25 Feb 2005 00:16:48 +0000
Message-ID: <20050225001648.GB29756@earth.dsh.org.uk>
References: <20050224142958.GA15691@earth.dsh.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050224142958.GA15691@earth.dsh.org.uk>
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

On Thu, Feb 24, 2005 at 02:29:58PM +0000, Ian Norton wrote:
> Hi everyone,
> 
> I hope somoene can give me some pointers here, Im writing an 
> implementation of ipcomp for 2.4.x using netfilter hooks instead
> of the normal way new protocols are handled, I know it's not 
> what netfilter is intended to do, but, the main idea here is
> that it is one of those 'there is more than one way to do stuff'
> exercizes for a university project.
> 
> basically, my problem is this, when recieving a compressed packet,
> i want to decompress it, expand the skb and memcpy the decompressed
> data into the skb.
> 
> now, i seem to be able to do all this, if i make a clone of this skb and send
> it using dev_queue_xmit or netif_rx() then it turns up where i want it
> (albiet later than i would like and requireing some link layer header stuff)
> 
> i really want to return the 'modified' skb back to netfilter with NF_ACCEPT
> however if i do a pskb_expand_head() on it, then it is as if i did nothing
> to the packet after calling pskb_expand_head().
> 
> afaik, pskb_expand_head() will create a copy of the skb if it needs to, how can
> i make sure that netfilter will see this new larger copy?

If I cant do that, is there a way to 'replace' the current packet with a new
one (so that subsequent hookfns get the new packet instead)?

By any chance, are the skb's sent to hookfns cloned? if so, would this mean i
can alter as much as i like in the skb->data area, but anything outside of the
original skb's data area will get lost ?

Ian
