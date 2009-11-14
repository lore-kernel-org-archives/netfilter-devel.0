From: Pranab Tandon <pranabtandon@tataelxsi.co.in>
Subject: Re: Moving sk_buff manipulation to userspace?
Date: Sat, 14 Nov 2009 19:52:53 +0530
Message-ID: <4AFEBD3D.8090108@tataelxsi.co.in>
References: <8363055a0911132324sbc60466h1c8f45fddf48b21a@mail.gmail.com> <4AFEBCC4.8020104@tataelxsi.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPIN1.mailsecure.in ([121.241.224.1]:50532 "EHLO
	smtpin1.mailsecure.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZKNOhc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2009 09:37:32 -0500
In-Reply-To: <4AFEBCC4.8020104@tataelxsi.co.in>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pranab Tandon wrote:
> Hi Justin Yaple,
>                       I too am new to the Netfilter thing but as far 
> as I know you can manipulate the " TCP data segment, and TCP header 
> section "  of the packet which you have qued using NF_QUEUE.IF you are 
> using the  nfqnl_test.c
>
> see here in the function
> static u_int32_t print_pkt (struct nfq_data *tb)
> {
> ..............
> ret = nfq_get_payload(tb,(char*)&data);
>
> .........
> here you will have you packet in the buffer named data
>
> This buffer usually will contain ipheader->IP 
> Payload[TCP-Header]->[TCP payload].....etc
> You can manipulate this buffer and reinject into the kernel.
> using this function
>
> nfq_set_verdict(qh, id, NF_ACCEPT, sizeof(data),data);---->here 
> NF_ACCEPT tells that  manipulated packet should traverse the kernel 
> path as usual after modification , sizeof(data) is the new size of 
> packet after modification and last is the pointer to the buffer which 
> contains the packet which you have manipulated.
>
> So if you plan to use the same code as in nfqnl_test ,your call back 
> function should be something like this
>
>
>
> static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
>          struct nfq_data *nfa, void *data)
> {
> unsigned char *data; //The pointer to the buffer.
> int id = 0,i;
>    struct nfqnl_msg_packet_hdr *ph;
>
> ph = nfq_get_msg_packet_hdr(tb);
>    if (ph) {
>        id = ntohl(ph->packet_id);   //You need this id to reinject the 
> packet back into the kernel.
>        printf("hw_protocol=0x%04x hook=%u id=%u ",
>            ntohs(ph->hw_protocol), ph->hook, id);
>    }
> //Code manipulation of the packet.make sure u take care of checksum.
>
>    printf("entering callback\n");// Code for packet processing doen here.
>  nfq_set_verdict(qh, id, NF_ACCEPT, sizeof(data),data);//This line 
> will re inject the packet back in to the kernel .Here u can use any 
> other buffer to keep and manipulate the packet.
> }
>
> Should there be any question comments or queries ,please mail me..I 
> will be happy to help.And as for readers I said i am new to Netfilter 
> so please feel free to tell me if I am wrong.
>
> Thanks
>
>
>
> Justin Yaple wrote:
>> Greetings,
>>
>> I have finished a prototype for a WAN accelerator that users netfilter
>> hooks to intercept packets that are being forwarded.  It then does
>> some checks, and potentially compresses the TCP data segment using an
>> LZ compression method.  Pretty neat stuff you guys have done here.
>>
>> I would like to do more than strictly compressing the data, but due to
>> the netfilter hook running in an interrupt context I am quite limited.
>>  So I found that using NF_QUEUE its possible to move processing to a
>> userspace process.
>>
>> Will moving the processing to a userspace application prevent me from
>> directly modifying the sk_buff though?  Particularly I need to
>> maintain the capability of modifying the TCP data segment, and TCP
>> header section.  I was looking at the example
>> trunk/libnetfilter_queue/utils/nfqnl_test.c, but there is nothing in
>> there about how to manipulate the sk_buff once its been received.  Is
>> this even possible using the NF_QUEUE?
>>
>> Thanks,
>> Jusitn.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
>
>



