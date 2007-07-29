From: Michael Guntsche <mike@it-loops.com>
Subject: Porting the RTSP module to 2.6.22
Date: Sun, 29 Jul 2007 22:12:28 +0200
Message-ID: <E625DC58-856F-43BE-BAE8-CF8536F53BE3@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,

I am trying to forward port the RTSP module from 2.6.21 to 2.6.22 and  
I am nearly done. All there is missing is a helper function. I had a  
look at the skbuff struct but I could not find out what needed to be  
changed.

Here is the short original helper function.

static void
get_skb_tcpdata(struct sk_buff* skb, char** pptcpdata, uint*  
ptcpdatalen)
{
     struct iphdr*   iph  = (struct iphdr*)skb->nh.iph;
     struct tcphdr*  tcph = (struct tcphdr*)((char*)iph + iph->ihl*4);

     *pptcpdata = (char*)tcph + tcph->doff*4;
     *ptcpdatalen = ((char*)skb->h.raw + skb->len) - *pptcpdata;
}

I changed this to

static void
get_skb_tcpdata(struct sk_buff** skb, char** pptcpdata, uint*  
ptcpdatalen)
{
     struct iphdr*   iph  = ip_hdr(*skb);
     struct tcphdr*  tcph = (void *)iph + iph->ihl*4;

     *pptcpdata = (char*)tcph + tcph->doff*4;
     *ptcpdatalen = ((char*)skb->h.raw + skb->len) - *pptcpdata;
}

I am pretty sure, that the first three lines are ok. But the last one  
is giving me some problems, since "h" is no longer in the skb struct.
Maybe someone with a little bit more knowledge about the changes can  
help me here.

Kind regards,
Michael
