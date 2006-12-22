From: "safiudeen" <safiudeen@todaktech.com>
Subject: Network compression...
Date: Fri, 22 Dec 2006 11:39:50 +0800
Message-ID: <200612221139.AA2964652346@todaktech.com>
Reply-To: safiudeen@todaktech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,

I want to  compress TCP/IP packet (payload and IP header) in out going packet and uncmpress in incomming packet. Is it possible to do this using netfilter hook ?. If possible what type of network  hook  can be used ?.

I tryed adding a fiew code in side linux kernel TCP/IP stack netif_rx () call and  dev_queue_xmit (), but kernel hang after fiew second.

If someone already done similor work or know how to do this please provide me some informatiom.

Thank you very much.

Regards
Safiudeen
