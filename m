From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Sat, 22 May 2004 01:01:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AE8A42.9060908@eurodev.net>
References: <Pine.LNX.4.33.0405211325150.7455-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0405211325150.7455-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Jozsef Kadlecsik wrote:

>>a) Sometimes we destroy the conntrack calling
>>conntrack->timeout.function((unsigned long)conntrack) but we are
>>returning -NF_ACCEPT, so we are calling implicitely nf_conntrack_put
>>from conntrack core, could we have any unexpected problem?
>>    
>>
>
>Good catch, this is one of the rare cases where conntrack must explicitly
>drop the packet, so the return value should be -NF_DROP. (-NF_ACCEPT does
>not guarantee that the packet will truly be dropped, as it was discussed
>in the previous mail.)
>  
>

still one question, some tracing:

conntrack->timeout.function is death_by_timeout -> which calls 
ip_conntrack_put -> which calls nf_conntrack_put  which decrements 
refcount and if zero, we release the conntrack.

Now we return -NF_whatever, from conntrack core we call 
nf_conntrack_put, so same thing, we reduce refcount and if zero, we 
release the conntrack.

I don't know if I'm missing anything but we are decrementing twice 
conntrack refcount, at worst we could try to release an already released 
conntrack. Am I missing anything?
 

>Actually, I'm really glad that there are guys who goes trough the code,
>work hard to understand and try to improve, optimize it.
>

I do also appreciate that some people like you consider that my efforts 
are not a waste of time :-)

> We have been
>planning to submit the code for kernel inclusion for a long time, but
>it cannot be done lightheartedly, without a wider (known) test base and
>code scrutinizing by more people.
>  
>

I think that this could be an interesting new feature, as well as those 
patches to make fine grain locking in conntrack which still need some 
spins and Patrick's ipsec... well, there are interesting stuff in pom-ng.

>Compared to the cvs version, the following modifications has been added to
>my tree:
>
>- tcph->ack should be tcph->ack_seq in tcp_packet at TCP_CONNTRACK_CLOSE
>  case
>- inlined segment_seq_plus_len
>- explicit drop of SYN/ACK when the state machine is out of sync
>- releasing lock moved up, after setting timeout parameter in tcp_packet
>- IPS_ASSURED_BIT is checked before set in tcp_packet
>- SACK support added
>  
>

two issues missing:
- sender->loose decrements misplaced
- use of defined flags in tcp.h

and pending that you give your ok:
- fine grain locking for private tcp helper info

regards,
Pablo
