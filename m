From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: skb->h not initialized
Date: Thu, 28 Dec 2006 19:15:10 +0100
Message-ID: <459409AE.9070402@netfilter.org>
References: <Pine.LNX.4.61.0612281733550.23545@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0612281733550.23545@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> while writing a netfilter match module I found that, when run,
> skb->h.th is not set to the TCP header (it is assured that the packet 
> _is_ TCP), as this printk shows me:
> 
> skb: h.th=cb5bc4dc nh.iph=cb5bc4dc mac.raw=cb5bc4ce head=cb5bc400 
> data=cb5bc4dc tail=cb5bc510 end=cb5bc580
> 
> Is it intended that skb->h.th is not set to skb->data + length of ip 
> header (skb->data+protoff as far as netfilter matches are concerned)?

The netfilter hooks are placed in the network layer, therefore skb->h.th
is not set in the input path since the packet did not reach the
transport layer yet (prerouting/input), but it is set in the output path
because it already passed by the transport layer (output/postrouting).

BTW, I'm unsure that this can be of interest in the linux-kernel list,
please there's no need to cc everyone. Use netfilter or linux-net
instead next time.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
