From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Fri, 14 Feb 2003 14:42:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E4CF238.2030207@trash.net>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030214080612.GN14794@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>From https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=48
>
>  
>
>>ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
>>refragments them at POST_ROUTING without careing about IP_DF. packets
>>with IP_DF|IP_MF can be refragmented with a different size, so path
>>mtu discovery is broken.  Linux nfs itself sends out packets with
>>IP_DF|IP_MF.
>>
>>------- Additional Comments From Harald Welte 2003-02-14 09:02 -------
>>
>>This is a really hard issue. 
>>
>>The problem is that we _need_ to defragment at NF_IP_PRE_ROUTING in
>>order to have the be able to do connection tracking.  So at this point
>>we would need to save the sizes of all individual fragments.  This
>>would enable us to re-fragment to exactly the same size at
>>POST_ROUTING. 
>>
>>Another obvious approach was to check for IP_DF and see if it is
>>bigger than the MTU of the outgoing interface.  The problem is: before
>>we do conntrack at NF_IP_PRE_ROUTING we don't know what potential NAT
>>bindings apply to this connection/packet - and thus don't know the
>>outgoing interface [that's why it's called PRE_ROUTING].
>>
>>And then, what happens if NAT has to resize (enlarge/shrink) a packet.
>>How should we deal with this while re-fragmenting? 
>>
>>I think this needs some good discussion at netfilter-devel...
>>    
>>
>
>So what are we going to do?  Does anybody have an alternative (viable?)
>approach?  
>
>And if we go for my first propsal, how/where would we store the
>list-of-fragment-sizes?  We certainly don't want it to be dynamically
>allocated... but according to RFC791 there kan be 8192 fragments of 8
>octets each...
>

Usually all fragments except the last one will have equal size, so the 
fragment
sizes can be stored as (size, boundary) tuples. I would suggest making 
the max.
number of different fragment sizes fixed or controllable via sysctl and 
set it to some
low default (like 4). This would reduce the amount of memory per 
reassembled packet
to 4 * (2b + 2b) = 16b.

Bye,
Patrick
