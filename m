From: "hMax Roth" <mroth2002@hotmail.com>
Subject: Re: Question about mac addresses in IP hook.,
Date: Tue, 17 Sep 2002 03:45:09 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F165KUFcShw8pCjAZK0000143d8@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org, DanE@aiinet.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bof@bof.de
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



>>Thanks for the response.
>>On the NF_IP_PRE_ROUTING I can get the mac header without a problem (what 
>>a
>>relief! Thanks for the help, it really helped a lot) Basically, it's 
>>always
>>14 bytes before the data pointer or on the .mac union.  However, the
>>outbound hook, the mac address pointer is still randomly NULL and pointing
>>to strange data! I can't understand it.  The code looks something like 
>>this
>>
>><in NF_IP_LOCAL_OUToutbound hook>

>Stop right there. For outbound packets, all the way through to
>POST_ROUTING, there is NO WAY the outbound ethernet header could
>already be in place for all cases. Think about sending to a station
>which is not yet in the local ARP cache. Before the kernel can be
>sure of the destination MAC address, it keeps back the original
>outgoing packet, makes an ARP broadcast, and only when it hears
>back, can it send on the packet on its journey.

Really? How can this be? So, you're telling me that if the mac address is 
not in the arp cache table it *queues* the packets? Who designed this? Is it 
going to queue all my packets should there be no reply to the arp? Nahh, I 
think you are mistaken.  Most likely, it probably drops the packet should 
there be no arp cache. Then the TCP/IP restart would allow enough time to 
see if the machine can find the destination. (i think windows does this)

>If what you naively expect, must be implemented, then all filtering
>action has to be postponed to the moment where the outgoing header
>is completely determined - doing so would need an almost complete
>rearrangement of the output path of iptables (and probably much
>meddling with the network stack itself). Furthermore, it would open
>the possibility for to-be-blocked traffic to neccessiate traffic,
>namely the ARP request/reply.

It's not as difficult as you may think (see above.)

>
>Can you see why things are the way they are, now?
>(There is a small chance, that I'm wrong for the POST_ROUTING hook.
>Somebody please correct me if that hook guarantees L2 header
>availability. I haven't looked closely at the code, so far.)
>
>best regards
>   Patrick




_________________________________________________________________
Join the world’s largest e-mail service with MSN Hotmail. 
http://www.hotmail.com
