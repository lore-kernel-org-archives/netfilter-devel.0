From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_queue large packets problem
Date: Fri, 24 Feb 2006 06:16:19 +0100
Message-ID: <43FE96A3.5090004@trash.net>
References: <43FE3AC8.7000809@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <43FE3AC8.7000809@net.in.tum.de>
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

Gregor Maier wrote:
> Hi,
> 
> I think I encountered a problem when using libnetfilter_queue with
> packets larger than the recv buffer specified when recv()-ing from the
> socket of the queue.
> 
> The kernel truncates(*) the packet delivered to userspace an thus
> nfnl_handle_packet() returns -1 (**), since there's a mismatch between
> the length of the buffer and the recorded length in struct nlmsghdr.
> This means that the callback function is never called an therefore we
> are never able to issue a verdict for the packet and the packet is stuck
> forever.

It seems libnetfilter_queue somehow must deal with errors reported to
the socket. I'm thinking of something like adding sequence numbers to
the queued packets and flushing all queued packets with sequence
numbers above the last successfully received one when an error is
reported. Alternatively we could use NLM_F_ACK and expect userspace
to acknowledge successfully received packets.
