From: "Kanhu Rauta" <choiskanhu@gmail.com>
Subject: Problem with IP defragmentation in 2.6 kernel
Date: Mon, 12 Mar 2007 15:46:58 +0530
Message-ID: <4c348ac20703120316s69dcae09j23f8ad62ef8e98d7@mail.gmail.com>
References: <4c348ac20703120314g398f546cqf7cf9fe59f26aae8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4c348ac20703120314g398f546cqf7cf9fe59f26aae8@mail.gmail.com>
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

Hi list,

I am using kernel 2.6.18.6. I have written a module,which will
register a function at local_in hook, i have found a strange behavior
with the packets getting in my callback function i.e

MTU=1500 varified with ifconfig.

[let say i am sending 1500 bytes to this machine from the network]
ping -s 1500 <ip>

1>in case of fragmention i am getting only one packet at the
hook,While analyzing the ip header it says this is the assembled
packet.

VER:4 hlen:5 tos:0
total-len:1528 id:40330 frag-offt:0
ttl:125 proto:1 cksum:64065
src=10.77.139.252  dst:10.77.152.6

skb->len:1528 tail-data len:1500
{This is where my doubt is,how these two lengths are varying, With 2.4
i got both same. Is it a bug with kernel 2.6 or its a design change.}

While dumping the data(for 0 to 1528 print skb->data[i]) it shows that
only 1472 bytes are valid data and rest 28 bytes are something
garbage.
I verified this with ethereal.

Also i have verified that the skb i got containes the 1472 bytes of
valid dat and rest 28 bytes are contained in
skb_shinfo(skb)->frag_list.

So i am doing the assemble in my hook like this....
if(skb->len > skb->tail-skb->data){
temp=skb_shinfo(skb)->frag_list;
while(skb->len > skb->tail-skb->data){
if(temp==NULL)
printk("Fragmented Data is NULL\n");
else if((skb->end-skb->tail)>temp->len){
strncpy(skb->tail,temp->data,temp->len);
skb->tail+=temp->len;
}
if(temp->next != NULL) temp=temp->next;
else{ printk("Fragmentation finished\n"); break ;}
}


Doing this i am able to get the complete packet, Is it the right way ?
                    or
Is there any other way to get the complete packet in local in hook ?



With Regards,
  kanhu
