From: Ian Norton <bredroll@darkspace.org.uk>
Subject: Re: To send a  skb  cloned in netfilter HOOK out
Date: Wed, 9 Mar 2005 09:47:30 +0000
Message-ID: <20050309094729.GA25404@earth.dsh.org.uk>
References: <002a01c51ae2$de33b970$18a8a8c0@archills>
	<20050225094855.GA8697@earth.dsh.org.uk>
	<001d01c5246b$63b3b730$02010101@archills>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Archills Zhao <archills_81@yahoo.com.cn>
Content-Disposition: inline
In-Reply-To: <001d01c5246b$63b3b730$02010101@archills>
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

Hi,

You can't send a 'cloned' skb, you need to send a copy to each destination,

ie, 

new_skb = skb_copy(old, GFP_ATOMIC);

A clone will share the same data with the original but different values in
head.

A copy will have a copy of the data and relavant head pointers.

to send the copy out of another interface you need to also tell netfilter that
it is not the same packet that went in.

http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-6.html

Ian

On Wed, Mar 09, 2005 at 01:45:51PM +0800, Archills Zhao wrote:
> Hi,
> How are things going on with you?
> If u copy the skb more than once and send to different destination, just as I am doing here,I guess u have some change to the netfilter itself!
> I am supposing to do the same thing next stage.
> 
> but now I have met a problem here ,and hope i can reach ur help.
> 
> Here I cloned the skb for more than once at POSTROUTING chain,chaged the destIP respectively,and then send them using dev_queue_xmit(skb). 
> but it turns out to have the same destination MAC address, 
> even if i called  ether.c:eth_rebuild_header();
> the destMAC remains the same.
> do u have any suggestion ,how can i change destMAC under my circumstance?
> 
> thanks in advance!
> 
> 
> Brgds,
> Archills
> 
> 
> 
>  
> 
>   ----- Original Message ----- 
>   From: Ian Norton 
>   To: Archills Zhao 
>   Sent: Friday, February 25, 2005 5:48 PM
>   Subject: Re: To send a skb cloned in netfilter HOOK out
> 
> 
>   On Fri, Feb 25, 2005 at 10:36:40AM +0800, Archills Zhao wrote:
>   > Hi,
>   > 
>   > for example, to register a module in NF_IP_POST_ROUTING, in which skb was cloned and stored in my_skb,
>   > If i want this cloned packet to follow the routine to finally be sent out,
>   > where should i inject this "myskb"?how to realise this in network satck?
>   > 
>   > i have run into netfilter for just one or two week and found it really nice!
>    
>   Hi there,
> 
>   I've been looking to do almost exactly the same thing here, 
>   You can create a whole new packet (you need to add link layer headers) 
>   and send that using dev_queue_xmit(skb). 
> 
>   At the moment I've not been able to send a _new_ skb back to the netfilter 
>   hook that called my module.
>   --
>   Ian
> 
> 

-- 
Ian Norton-Badrul
