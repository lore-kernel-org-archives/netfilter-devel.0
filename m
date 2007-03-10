From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: IP Defragmentation
Date: Sun, 11 Mar 2007 00:43:34 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703110042460.26332@yvahk01.tjqt.qr>
References: <4c348ac20703072215x63a7a315kd018e433c7a197d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-net@vger.kernel.org, kernelnewbies@nl.linux.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
To: Kanhu Rauta <choiskanhu@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4c348ac20703072215x63a7a315kd018e433c7a197d2@mail.gmail.com>
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


On Mar 8 2007 11:45, Kanhu Rauta wrote:
>
> 1>in case of fragmention i am getting only one packet at the
> hook,While analyzing the ip header it says this is the assembled
> packet(skb->len=1528,offset=0,MF=0).

conntrack assembles defragmented packets.

> While dumping the data(for 0 to 1528 print skb->data[i]) it shows that
> only 1472 bytes are valid data and rest 28 bytes are something
> garbage.

Have you forgotten to use skb_header_pointer()?



Jan
-- 
