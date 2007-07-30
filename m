From: Patrick McHardy <kaber@trash.net>
Subject: Re: Porting the RTSP module to 2.6.22
Date: Mon, 30 Jul 2007 14:38:03 +0200
Message-ID: <46ADDBAB.3050705@trash.net>
References: <E625DC58-856F-43BE-BAE8-CF8536F53BE3@it-loops.com>
	<D1E7007A-5FE3-4D88-8991-A9C1339F4EEB@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Michael Guntsche <mike@it-loops.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <D1E7007A-5FE3-4D88-8991-A9C1339F4EEB@it-loops.com>
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

Michael Guntsche wrote:
> Answering my own post.
> I already fixed the obvious mistake I made.
> On Jul 29, 2007, at 22:12, Michael Guntsche wrote:
> <snip>
> 
>> I changed this to
>>
>> static void
>> get_skb_tcpdata(struct sk_buff** skb, char** pptcpdata, uint* 
>> ptcpdatalen)
>> {
>>     struct iphdr*   iph  = ip_hdr(*skb);
>>     struct tcphdr*  tcph = (void *)iph + iph->ihl*4;
>>
>>     *pptcpdata = (char*)tcph + tcph->doff*4;
>>     *ptcpdatalen = ((char*)skb->h.raw + skb->len) - *pptcpdata;
>> }
>>
> 
> Of course there is no need to change skb.
> Sorry for not checking this before sending the first E-Mail.
> 
> static void
> get_skb_tcpdata(struct sk_buff* skb, char** pptcpdata, uint*  ptcpdatalen)
> {
>     struct iphdr*   iph  = ip_hdr(skb);
>     struct tcphdr*  tcph = (void *)iph + iph->ihl*4;
> 
>     *pptcpdata = (char*)tcph + tcph->doff*4;
>     *ptcpdatalen = ((char*)skb->h.raw + skb->len) - *pptcpdata;
> }
> 
> The problem remains though that the "h" member is no longer existing.


That shouldn't be a problem since netfilter modules should basically
never use it anyway since its only valid for locally generated packets.
Use Jan's suggestion (or look at other modules) and skb_header_pointer.
