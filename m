From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: how to create a TCP packet w/data in interrupt context?
Date: Fri, 25 Mar 2005 09:30:06 -0500
Message-ID: <876ef97a0503250630514919a8@mail.gmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-net <linux-net@vger.kernel.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
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

Hi all,

I want to be able to create a TCP packet in an iptables rules, similar
to what REJECT --reject-with tcp-reset does, but this packet needs
some data to go in the payload. Is there some iptables rule or kernel
subsystem that already does this that I could look at for reference?
Or, does anyone have an idea of how I would go about doing this? I
already have a n RST that I am creating before this (a la REJECT), so
I figured I would just skb_copy_expand() that packet and add the
payload, but I'm not sure which fields in which structures need to be
updated when I do that.

I looked at pktgen, but that creates UDP packets. I also looked at the
TCP stack, but that copies its data from userland and I wasn't sure if
that series of operations would be the same from an iptables rule in
interrupt context. Anybody have any ideas on how to do this? Thanks.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
