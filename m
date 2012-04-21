From: Arif Hossain <aftnix@gmail.com>
Subject: Re: concatenate udp payloads of multiple packet
Date: Sat, 21 Apr 2012 15:12:47 +0600
Message-ID: <CAGuaRCsyjc53pKrWWKhfLSPczZQtif4zRPqwuAvYN2fdZBhV2Q@mail.gmail.com>
References: <CAGuaRCt0Jmj4_prCZVvXi2oijOTprTqUntphjx_9cQqk-nqhCQ@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE01687C@HQ-EX01.bytemobile.com>
	<CAGuaRCs6iYTL-Teci4GpOPD8Cm-6CbLUh2gYbDQMteA=nF29ug@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE0169BE@HQ-EX01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jeff Haran <jharan@bytemobile.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <471DE477E2B1F549A58F3A14A27180BE0169BE@HQ-EX01.bytemobile.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Apr 20, 2012 at 11:17 PM, Jeff Haran <jharan@bytemobile.com> wrote:
> Nothing prevents you from having multiple NFQUEUEs using the queue-balance option to the NFQUEUE target. From the iptables man page:
>
> "NFQUEUE
>
> This target is an extension of the QUEUE target. As opposed to QUEUE, it allows you to put a packet into any specific queue, identified by its 16-bit queue number. It can only be used with Kernel versions 2.6.14 or later, since it requires the nfnetlink_queue kernel support. The queue-balance option was added in Linux 2.6.31.
> --queue-num value
> This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
> --queue-balance value:value
> This specifies a range of queues to use. Packets are then balanced across the given queues. This is useful for multicore systems: start multiple instances of the userspace program on queues x, x+1, .. x+n and use "--queue-balance x:x+n". Packets belonging to the same connection are put into the same nfqueue."
>
> However, on each of those queues, when you read a packet from the socket to the queue you have to return a verdict on that packet before you get any more packets off that socket. At least that's what I've observed.
>
> Jeff Haran
>

I do use the queue-balance option to use multiple cores of the
machines by means of separate application.

But for my purpose, concatenation of udp payload this does not help.
What i've come to understand that there is no straight forward way to
achieve this.

But if i do this in following way would that work:

I will save the udp payload in a user   managed queue and set the
verdict as NF_DROP to every packet. after creating the concatenated
packet, i will forward the message to the udp daemon.

What are difficulties i may face if i chose to do it in this way?



-- 
-aft
