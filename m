From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Tue, 18 May 2004 23:10:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AA7BC5.1000906@eurodev.net>
References: <Pine.LNX.4.33.0405171427460.29543-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.33.0405171427460.29543-100000@blackhole.kfki.hu>
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

Patrick, would be better if we use these flags instead of TCPCB_*?

http://lxr.linux.no/source/include/linux/tcp.h#L105

Now some questions for Jozsef...

Jozsef Kadlecsik wrote:

>>b) check that tcp is not malformed (doff has a faked value): I trust the
>>value of skb->len, so we could use it to check that the doff is correct
>>instead of that skb_copy_bits and that buff var, couldn't we?
>>    
>>
>
>No, I think we cannot avoid calling skb_copy_bits two times: first for the
>minimal TCP header and secondly for the whole TCP header. In your patch
>you trim the options off, by which we'd loose window scaling support.
>  
>

I missed that, so couldn't we call skb_copy_bits just once?, I mean:

        if (skb_copy_bits(skb, iph->ihl * 4, buff, tcph->doff * 4) != 0)
                return -NF_ACCEPT;

>>c) I replaced this:
>>    
>>
>[...]
>  
>
>>d) I think that we don't need this anymore, this is part of the old
>>tracking:
>>    
>>
>
>No, we cannot do that: out of window TCP packets could result status
>changes or to drop connections.
>  
>

I also missed that! I didn't see that if we saw a FIN packet the state 
could change, anyway I don't understand this artefact in tcp_in_window.

        /* Ignore data over the right edge of the receiver's window. */
        if (after(end, sender->td_maxend) &&
            before(seq, sender->td_maxend)) {
                end = sender->td_maxend;
                if (state->stored_seq == TCP_FIN_SET)
                        state->stored_seq = TCP_ACK_SET;
        }

why if we saw a FIN packet, we modify stored_seq to TCP_ACK_SET? I got 
confused while having a look at the state table, if old state was 
Established and we saw a FIN packet which complies with that condition, 
we will keep in state Established, so we are ignoring that FIN packet.

new_state = tcp_conntracks[dir][conntrack->tcp.stored_seq][old_state]

mmm, is that a trick to handle FIN+ACK? please, give a clue :-)

>>f) Do you think that it's interesting adding fine grain locking in
>>tcp-window-tracking?
>>http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015166.html
>>    
>>
>
>First I was not quite convinced, but yes, I think it'd worth. However I
>believe we should introduce a generic per data locking in ip_conntrack
>instead of just a per TCP data locking. Thus there were no need the extra
>per protocol-helper locks either.
>  
>
yes, that would be also ok, but some other helpers like udp don't need 
it, so is it worthy adding that field to the conntrack structure?

Another observation:

if (sender->loose)
    sender->loose--;

I think that we should decrease sender->loose inside this if condition:

        if (sender->loose || receiver->loose ||
            (before(end, sender->td_maxend + 1) &&
             after(seq, sender->td_end - receiver->td_maxwin - 1) &&
             before(ack, receiver->td_end + 1) &&
             after(ack, receiver->td_end - MAXACKWINDOW(sender))))

because initially sender->loose is 3 (or whatever was set via sysctl), 
we check that sender->loose is non-zero and decrement, so that if 
condition above would be true only for first two packet, third packet 
won't get in. I mean, if we set ip_ct_tcp_loose to 3, actually we will 
only consider first 2 packets, and we'll check if third packet is inside 
those 4 defined boundaries.

regards,
Pablo
