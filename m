From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Let arptables see bridged arp traffic
Date: Thu, 19 Jun 2003 12:39:01 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030619.123901.15260451.davem@redhat.com>
References: <200306192124.34286.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bdschuym@pandora.be
In-Reply-To: <200306192124.34286.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Bart De Schuymer <bdschuym@pandora.be>
   Date: Thu, 19 Jun 2003 21:24:34 +0200

   The patch below introduces the NF_ARP_FORWARD hook to let arptables
   see bridged arp traffic, as discussed in a previous mail.

Applied, thanks a lot Bart.
