From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] ipt_REJECT shouldn't send replies for wrong udp csum
Date: Fri, 10 Jan 2003 00:52:23 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110.005223.97382361.davem@redhat.com>
References: <20030109144641.GI9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20030109144641.GI9467@sunbeam.de.gnumonks.org>
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
   Date: Thu, 9 Jan 2003 15:46:41 +0100

   Author: Patrick McHardy <kaber@trash.net>
   ipt_REJECT sends unreachables in response to UDP packets with invalid
   checksums, thereby exposing the existance of a firewall  (as described
   in phrack #60, "broken crc firewall spotting" (or something like this),
   www.phrack.com).  The patch makes ipt_REJECT verify UDP checksums if
   set.                         
   
Applied, thanks.
