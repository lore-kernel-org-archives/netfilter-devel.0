From: Jvalencia <tigrezno@log01.org>
Subject: Re: libipq: man page != online doc and a question
Date: Sat, 16 Oct 2004 17:59:21 +0100
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041016175921.71c207d0.tigrezno@log01.org>
References: <20041015192145.383e8bd9.tigrezno@log01.org>
	<41714C50.8060400@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <41714C50.8060400@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 16 Oct 2004 18:29:04 +0200
Pablo Neira <pablo@eurodev.net> wrote:

> Jvalencia wrote:
> 
> >I've been looking at ipq_set_verdict man page, finding two verdicts: NF_ACCEPT and NF_DROP.
> >  
> >
> 
> correct
> 
> >This man page dates from 2001 :S
> >
> >Online netfilter hacking guide tells about NF_ACCEPT, NF_DROP, NF_QUEUE and NF_REPEAT.
> >  
> >
> 
> yes, these are all possibles verdicts in a *kernel hook*, not in ip_queue

mmm but I was able to use NF_QUEUE in ipq_set_verdict using libipq.

ipq_set_verdict(h, m->packet_id, NF_QUEUE, 0, NULL);
Exit code was 28, a success.

> 
> >Can I send the packet to another chain with verdicts?
> >  
> >
> 
> what do you mean?
> 

In iptables you have various chains, as INPUT, OUTPUT and other user created as "icmp_traffic" for example. 
I want to move a packet to a chain as "strange_traffic" from libipq because of its content. Is this possible?


> regards,
> Pablo
