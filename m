From: kernel exis <kernel@exis.cl>
Subject: NF_ARP_OUT skb has NULL link layer header
Date: Wed, 23 Jun 2004 14:07:33 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040623140733.1cd33800@mindrape>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I've been working lately on a netfilter hook extension which rewrites outgoing ARP packets to spoof a host's MAC address.

I've succesfully spoofed ARP replies, but have seen that several OS's tend to update their arp cache based on information in ARP requests.
After several panic()'s, I noticed that the link layer header (skb->mac)
is NULL. My intention was to rewrite the ethernet mac address to the spoofed MAC address.

Is there a way to rewrite the link layer header besides modifying skb->mac (skb->mac.ethernet to be precise), or could I possibly just tag on a kmalloc()'ed pointer to the skb->mac?

If it makes any difference, I only noticed this when porting the code to linux 2.6 (2.6.7).

Thanks a lot, in advance

Phillip Whelan, EXIS (http://www.exis.cl)
