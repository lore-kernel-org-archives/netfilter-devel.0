From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue & QUEUE target
Date: Sun, 15 Jun 2003 20:07:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EECB5F4.7010004@trash.net>
References: <20030615155352.GD2103@lbsd.net> <3EECA7B2.5090300@trash.net> <20030615180031.GE2103@lbsd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nigel Kukard <nkukard@lbsd.net>
In-Reply-To: <20030615180031.GE2103@lbsd.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Nigel Kukard wrote:

>>netlink sockets provide unreliable communication. your problem is
>>probably the sockets receive queue overflowing. ip_queue then
>>returns a negative error code to nf_queue which drops the packet.
>>    
>>
>
>well i'm pumping through about 5,000 pkt/s, doing a few Mb/s. What would
>the best thing be to use? or how could i remedy this problem?
>
>i set the rcv buffer to a few Mb, and also the ipq_maxlen to 8196... is
>there anything else i can do?
>
>  
>
Probably not much, but did you make sure you also increased
/proc/sys/net/core/rmem_max ? If you don't mind your statistics
beeing wrong (better than high drop rates imho) you could
modify ip_queue so it nf_reinjects packets which could not
be sent instead of returning a error to nf_queue.

Bye
Patrick

>Regards
>Nigel
>
>  
>
