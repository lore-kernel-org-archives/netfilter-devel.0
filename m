From: Patrick McHardy <kaber@trash.net>
Subject: Re: A bug in IPQ or just my misunderstanding ?
Date: Sat, 30 Sep 2006 16:33:42 +0200
Message-ID: <451E8046.5080201@trash.net>
References: <451D5CC0.6060908@rawflow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Toby Bradshaw <tobyb@rawflow.com>
In-Reply-To: <451D5CC0.6060908@rawflow.com>
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

Toby Bradshaw wrote:
> Hi,
> 
> I've been trying to get userspace packet mangling to work with a simple
> example app. the main details of which are (cribbed from the usual
> example on the man pages):
> 
> case IPQM_PACKET:
> {
>    ipq_packet_msg_t *m = ipq_get_packet(buf);
>    status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, m->data_len,
> m->payload);
> 
>    if (status < 0)
>      die(h);
>    break;
> }
> 
> So i'm just basically just resubmitting the unchanged payload. This
> doesn't seem to work. If I copy the packet into new memory and submit it
> also doesn't work. A sanity-checking memcmp shows the two buffers to be
> identical.
> 
> I'm testing this by pinging a subinterface on my host (ifconfig eth0:1
> 192.168.8.150 up; ping 192.168.8.150). The iptables QUEUE is working
> fine, packets are delivered to my app.
> 
> If I don't submit a payload then as long as my app is running I'll get
> ping replies. If I swap to a version that does submit the payload, the
> replies stop. tcpdump proves that they're not being sent.
> 
> In the payload submitting case I also notice the following via dmesg:
> 
>    NF_IP_ASSERT: net/ipv4/netfilter/ip_nat_standalone.c:74(ip_nat_fn)
> 
> .. which appear to be an assert concerning fragmentation.
> 
> So.. am I not doing something right or is it possible this is a bug in
> ipq_set_verdict or perhaps in ip_nat_standalone.c ??

Looks like a bug. Which kernel version are you using, at what hook
are you queueing packets?
