From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] fixes for ipt_unclean.c
Date: Mon, 14 Oct 2002 04:20:23 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014.042023.27389949.davem@redhat.com>
References: <20021014132237.N13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20021014132237.N13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Harald Welte <laforge@gnumonks.org>
   Date: Mon, 14 Oct 2002 13:22:37 +0200

   It fixes two bugs:
   
   - packets with UDP sport == 0 are OK according to RFC768
   - UDP checksum is optional (old code required packet to have a checksum)
   
Harald, at least the UDP checksum fix is already in Marcelo's 2.4.x
tree.

Please recheck your patches against 2.4.20-pre10 which matches
what I currently have for 2.4.x networking, thanks!
