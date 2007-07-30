From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Porting the RTSP module to 2.6.22
Date: Mon, 30 Jul 2007 17:52:57 +0200
Message-ID: <FF2AE929-42AB-406A-949B-D88BB3BB4099@it-loops.com>
References: <E625DC58-856F-43BE-BAE8-CF8536F53BE3@it-loops.com>
	<Pine.LNX.4.64.0707292215200.9488@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707292215200.9488@fbirervta.pbzchgretzou.qr>
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


On Jul 29, 2007, at 22:21, Jan Engelhardt wrote:

>
>
> Use  (void *)iph + ip_hdrlen(*skb)
>
>>   *pptcpdata = (char*)tcph + tcph->doff*4;
>>   *ptcpdatalen = ((char*)skb->h.raw + skb->len) - *pptcpdata;
>> }
>
> h.raw is now skb_transport_header(skb);
> Also, skb-> should be (*skb)->, since it is a double pointer (which  
> you
> can also get rid of)
>

Thank you very very much Jan. With your tips  and some poking in the  
other modules I was able to get a compiling and more suprisingly  
running version of the RTSP module.

The new and working function looks like this.

static void
get_skb_tcpdata(struct sk_buff* skb, char** pptcpdata, uint*  
ptcpdatalen)
{
     struct iphdr*   iph  = ip_hdr(skb);
     struct tcphdr*  tcph = (void *)iph + ip_hdrlen(skb);

     *pptcpdata = (char*)tcph +  tcph->doff*4;
     *ptcpdatalen = ((char*)skb_transport_header(skb) + skb->len) -  
*pptcpdata;
}


I am in the process of creating and updated patch against 2.6.22.1  
and will put it up on my site this evening.
http://mike.it-loops.com/rtsp/
It is working for me right now, but maybe someone can give it a quick  
check and tell me if there are any problems or bugs.

Kind regards,
Michael
