From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] ECN target wrong tcp csum on little endian
Date: Fri, 10 Jan 2003 00:57:04 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110.005704.100662413.davem@redhat.com>
References: <20030109145046.GK9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20030109145046.GK9467@sunbeam.de.gnumonks.org>
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
   Date: Thu, 9 Jan 2003 15:50:46 +0100

   Author: Patrick McHardy <kaber@trash.net>
   
   The 2.4.20 kernel included the new iptables 'ECN' target, enabling a selective
   ECN disable mechanism.   Unfortunately there was a bug in the incremental TCP
   checksum update, resulting in broken TCP checksums on little endian machines.
   This patch fixes the Bug.
   
Applied, thanks.
