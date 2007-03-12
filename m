From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Problem with IP defragmentation in 2.6 kernel
Date: Mon, 12 Mar 2007 18:30:04 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703121829120.19469@yvahk01.tjqt.qr>
References: <4c348ac20703120314g398f546cqf7cf9fe59f26aae8@mail.gmail.com>
	<4c348ac20703120316s69dcae09j23f8ad62ef8e98d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Kanhu Rauta <choiskanhu@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4c348ac20703120316s69dcae09j23f8ad62ef8e98d7@mail.gmail.com>
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


On Mar 12 2007 15:46, Kanhu Rauta wrote:
> So i am doing the assemble in my hook like this....
> if(skb->len > skb->tail-skb->data){
> temp=skb_shinfo(skb)->frag_list;
> while(skb->len > skb->tail-skb->data){
> if(temp==NULL)
> printk("Fragmented Data is NULL\n");
> else if((skb->end-skb->tail)>temp->len){
> strncpy(skb->tail,temp->data,temp->len);
> skb->tail+=temp->len;
> }
> if(temp->next != NULL) temp=temp->next;
> else{ printk("Fragmentation finished\n"); break ;}
> }

Woha. *Blatant* violation of encapsulation (even if C does not
have a notion of encapsulation).

> Doing this i am able to get the complete packet, Is it the right way ?
>                   or
> Is there any other way to get the complete packet in local in hook ?
>
Like I said in my earlier reply, try using skb_header_pointer().


Jan
-- 
