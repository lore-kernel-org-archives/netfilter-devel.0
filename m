From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] udp nat helper support
Date: Fri, 10 Jan 2003 00:50:07 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110.005007.82443566.davem@redhat.com>
References: <20030109144512.GH9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20030109144512.GH9467@sunbeam.de.gnumonks.org>
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
   Date: Thu, 9 Jan 2003 15:45:12 +0100

   Author: Brian J. Murrell <netfilter@interlinx.bc.ca>
   This patch is necessarry for UDP nat helpers (like Amanda protocol)
   - make ip_nat_resize_packet() more generic (TCP and UDP)
   - add ip_nat_mangle_udp_packet() function similar to 
     ip_nat_mangle_tcp_packet()

Applied, thanks.
