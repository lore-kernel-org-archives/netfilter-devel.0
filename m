From: Ian Norton <bredroll@darkspace.org.uk>
Subject: Re: Modify an sk_buff from an NF_HOOK
Date: Wed, 2 Mar 2005 04:30:52 +0000
Message-ID: <20050302043052.GA3791@earth.dsh.org.uk>
References: <20050302015034.GA857@earth.dsh.org.uk>
	<876ef97a050301175865675641@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <876ef97a050301175865675641@mail.gmail.com>
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

On Tue, Mar 01, 2005 at 08:58:18PM -0500, Tobias DiPasquale wrote:
> On Wed, 2 Mar 2005 01:50:34 +0000, Ian Norton <bredroll@darkspace.org.uk> wrote:
> > Hi everyone,
> > 
> > I've been faffing about for well over two weeks now, and, have come almost to
> > the conculsion (as I hauntingly suspected) that 'any' changes to an skb that
> > involve changes outside of the original values of skb->head and skb->tail are
> > impossible to do safely.
> 
> No its not. How about some code, buddy? What exactly are you doing and
> where are you doing it?

Im aware Im probably doing it all wrong :-).

here goes,

my hook functions is registered at the NF_IP_LOCAL_IN with NF_IP_PRI_FIRST
after some testing to see if a packet contains eg IPCOMP going from some
specific ip, i pass the skb (via the original pointer i get from the hook) 
to a function to decompress the contents of the IPCOMP data.

Im doing this in 2.4.2x .

// registered with netfilter as my hook func 
unsigned int
compressed_rx (unsigned int nfhook, struct sk_buff **skb,
	      const struct net_device *in, const struct net_device *our,
	      int (*okfn) (struct sk_buff *))
{

	struct sk_buff *skbuff = skb;
	int rx_retval = NF_ACCEPT;

	/* ignore anything that isnt a packet with an IPComp payload */
	if (skbuff->nh.iph->protocol != PROTO_IPCOMP)
		return NF_DROP;

	/* stuff removed here for clarity, nothing to do with the skb */	

	return sk_buff_data_decompress (skbuff, ACTION_INFLATE_MANUAL);
}



/* decompress the data of an sk_buff according to it's cpi */
int
sk_buff_data_decompress (struct sk_buff *_skb, int action)
{
	void *zlib_output_start;	// we will put the decompressed payload here
	u8 zlib_output_buffer[MAX_PAYLOAD_SIZE];
	size_t zlib_output_size;	// the amount of memory requested at *zlib_output_start

	int output_bytes;	// set to the length of output from zlib
	size_t payload_size;	// the total size of the payload + ipcomp hdr
	size_t new_payload_size; // decompressed payload size
	size_t ipcomp_size;	    // same as payload_size
	size_t ipcomp_payload_size;	// the length of the ipcomp data
	size_t payload_size_delta; // absolute diff between payload_size and new_payload_size
	
	u8 payload_protocol;	// save the payload value from the ipcomp header

	struct iphdr *ip_head;	// the start of the IP (nh) in the sk_buff
	struct iphdr *orig_ip_head;
	size_t iphead_size;	
	
	pneumatic_header *ipcomp_head;

	void *payload_start;	// the start of the ip payload in the skb_buff
	void *ipcomp_payload_start;	// the start of the compressed data

	struct sk_buff *skb = _skb; // do work here	
	struct sk_buff *newskb;		
	
	ip_head = skb->nh.iph;
	payload_start = skb->h.raw;
	ipcomp_head = (pneumatic_header *) payload_start;
	ipcomp_payload_start =
			(void *) ipcomp_head + sizeof (pneumatic_header);


	payload_size = ntohs (ip_head->tot_len) - (ip_head->ihl * 4);
	ipcomp_size = payload_size;
	ipcomp_payload_size = ipcomp_size - sizeof (pneumatic_header);


	/* the proto number of the compressed data */
	payload_protocol = ipcomp_head->payload_proto;

	/* set space for decompressed output */
	zlib_output_size = (size_t) MAX_PAYLOAD_SIZE;
	zlib_output_start = &zlib_output_buffer;

    /* this works without any problems, i get correct decompressed data here */
	output_bytes = pneu_inflate_decompress (ipcomp_payload_start,
						 ipcomp_payload_size, zlib_output_start, zlib_output_size);

	// compression didnt work?!     
	if (output_bytes <= 0)
		return NF_DROP;


	// packet seemed to decompress ok,
	
	new_payload_size = (size_t)output_bytes;	// length of decompressed payload
	payload_size_delta = new_payload_size - payload_size; // increased by this length 
	
	if (skb_tailroom(skb) < payload_size_delta)
		return NF_DROP; // buffer didnt have enough space in. 
	

	// the payload decompressed ok here,
	// now expand the skb's data and put the result in the payload
	// of the ip packet.

	iphead_size = sizeof(struct iphdr);
	orig_ip_head = kmalloc( iphead_size, GFP_ATOMIC );
	if (! orig_ip_head )
		return NF_DROP;

	memcpy( orig_ip_head, skb->nh.raw, iphead_size);
		
	// adjust the data area to fit the new payload
	skb_put(skb, payload_size_delta);
		
	// now copy back the old ip header
	memcpy(skb->nh.raw , orig_ip_head ,iphead_size);
	kfree(orig_ip_head);

	skb->nh.iph->protocol = payload_protocol;	// set the old protocol's value
	skb->nh.iph->tot_len = htons (ntohs(skb->nh.iph->tot_len) + payload_size_delta);
		
	// copy the stuff we got from zlib into the skb's data area
	memcpy (skb->h.raw, zlib_output_start, (unsigned int) output_bytes);

	// update ip header csum
	ip_send_check(skb->nh.iph);

	// right now, i can see the entirety of the buffer, if i copy the skb
    // and send it to myself with netif_rx() i can see the whole buffer.

    // when netfilter releases the skb back to the application/linux,
    // I see the decompressed data but it is truncated to the length of the
    // original recieved skb.
			
	return NF_ACCEPT;
}

I hope this makes sense, Ive chopped quite a fair chunk out to do with some
conditions about when to ignore or when to decompress.

Thanks for your help :-)


-- 
Ian Norton-Badrul
