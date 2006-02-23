From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_queue: get link layer header
Date: Thu, 23 Feb 2006 11:03:51 +0100
Message-ID: <43FD8887.2050902@trash.net>
References: <43FB4989.7070901@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <43FB4989.7070901@net.in.tum.de>
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
> I was wondering if it's somehow possible to aquire the complete link
> level header in libnetfilter_queue. I can get the HW Protocol
> (Ethertype) and the SRC MAC but it is also possible to get the DST MAC.
> 
> I know that for outgoing packets the information is only available after
> the arp lookup (so in/after POSTROUTING) but for INPUT / FORWARD packets
> the DST Mac is always available. Maybe it would be a solution to set the
> DST MAC to all zeros if it's not yet known and then add a mechanism to
> pass the DST Mac to the userspace app listeing on the queue.

I agree that the current implementation isn't perfect since it always
asks the driver to fill in its own address, even if the received packet
was a broadcast packet, instead of using the data from the packet.
I've added it to my TODO list to look into this.
