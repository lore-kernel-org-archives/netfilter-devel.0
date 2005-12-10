From: Nhan Thanh Le <ltnhan@tma.com.vn>
Subject: How to get Ethernet data from Socket buffer.
Date: 10 Dec 2005 15:56:39 -0500
Message-ID: <1134248199.6530.21.camel@nhanle.tma.com.vn>
Reply-To: ltnhan@tma.com.vn
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
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

Hi All,

  My kernel module get data socket buffer from Netfilter, When I try to
copy data from socket buffer filed skb->mac.raw or skb->mac.ethernet to
my ethernet data then my computer will be hang on. Would you please show
me how to fix this? Or please help me to how fill my ethernet header
when I get data from socket buffer. Thank you very much and appreciate
for help.

Both function bellow is not work properly.

inline static int build_ethernet(const struct sk_buff *skb, struct
ethhdr vs_hdr)
{
  struct ethhdr *eth_header;
  eth_header=(struct ethhdr *)skb->mac.raw;  
  if (eth_header == NULL)
    return -1;
  memcpy(&vs_hdr,skb->mac.raw,sizeof(struct ethhdr));

  return 0;
}

inline static int build_ethernet(const struct sk_buff *skb,  struct
ethhdr vs_hdr)
{
  struct ethhdr *eth_header;
  eth_header=skb->mac.ethernet;  
  if (eth_header == NULL)
    return -1;
  memcpy(&vs_hdr,skb->mac.ethernet,sizeof(struct ethhdr));

  return 0;
}

Nhanle
