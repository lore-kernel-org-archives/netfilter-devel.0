From: Robbie Dinn <robbie@microbus.com>
Subject: Re: PPTP conntrack for kernel 2.6
Date: Tue, 17 Aug 2004 09:58:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4121C8BD.5030203@microbus.com>
References: <cfdmen$3hu$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <cfdmen$3hu$1@sea.gmane.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Laurens Blankers wrote:
> Could someone please port the pptp conntrack module to kernel 2.6?

I thought I would have a go at this. It is a bit harder to do
than I thought.

<aside>
At the moment I am stuck trying to fix up function gre_manip_pkt()
in ip_nat_proto_gre.c . I can change the function parameter to
match the function prototype, but I don't know to fix the code
in the body of the function.

I tried looking at functions udp_manip_pkt() and tcp_manip_pkt()
for guidance (in files ip_nat_protocol_{udp|tcp}.c), but I am still
confused.
</aside>

I think I might have spotted something that looks a bit strange,
maybe even a bug? Please bear in mind that I don't understand the
code.

Both udp_manip_pkt() and tcp_manip_pkt() make a call to
skb_ip_make_writable(). It is the second parameter passed to
skb_ip_make_writable() that I am worried about.

In udp_manip_pkt() it is called like this:

      if (!skb_ip_make_writable(pskb, hdroff + sizeof(hdr)))

where hdr is a pointer to a struct udphdr

In tcp_manip_pkt() it is called like this:

      if (!skb_ip_make_writable(pskb, hdroff + hdrsize))

where hdrsize may have a value of sizeof(tcphdr)

I am worried that sizeof(struct udphdr) and sizeof(struct udphdr *)
are different things.

Have I found a bug or am I simply confused?
