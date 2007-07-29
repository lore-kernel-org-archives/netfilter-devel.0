From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Porting the RTSP module to 2.6.22
Date: Sun, 29 Jul 2007 22:21:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707292215200.9488@fbirervta.pbzchgretzou.qr>
References: <E625DC58-856F-43BE-BAE8-CF8536F53BE3@it-loops.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Michael Guntsche <mike@it-loops.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <E625DC58-856F-43BE-BAE8-CF8536F53BE3@it-loops.com>
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


On Jul 29 2007 22:12, Michael Guntsche wrote:
>
> I changed this to
>
> static void
> get_skb_tcpdata(struct sk_buff** skb, char** pptcpdata, uint* ptcpdatalen)
> {
>   struct iphdr*   iph  = ip_hdr(*skb);
>   struct tcphdr*  tcph = (void *)iph + iph->ihl*4;

Use  (void *)iph + ip_hdrlen(*skb)

>   *pptcpdata = (char*)tcph + tcph->doff*4;
>   *ptcpdatalen = ((char*)skb->h.raw + skb->len) - *pptcpdata;
> }

h.raw is now skb_transport_header(skb);
Also, skb-> should be (*skb)->, since it is a double pointer (which you
can also get rid of)

> I am pretty sure, that the first three lines are ok. But the last one is giving
> me some problems, since "h" is no longer in the skb struct.
> Maybe someone with a little bit more knowledge about the changes can help me
> here.


	Jan
-- 
