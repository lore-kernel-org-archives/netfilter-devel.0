From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: skb->h not initialized
Date: Thu, 28 Dec 2006 17:42:42 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612281733550.23545@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kaber@trash.net
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753646AbWL1Qnf@vger.kernel.org>
To: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,


while writing a netfilter match module I found that, when run,
skb->h.th is not set to the TCP header (it is assured that the packet 
_is_ TCP), as this printk shows me:

skb: h.th=cb5bc4dc nh.iph=cb5bc4dc mac.raw=cb5bc4ce head=cb5bc400 
data=cb5bc4dc tail=cb5bc510 end=cb5bc580

Is it intended that skb->h.th is not set to skb->data + length of ip 
header (skb->data+protoff as far as netfilter matches are concerned)?


	-`J'
-- 
