From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix locking in ip_conntrack_change_expect()
Date: Mon, 14 Oct 2002 04:38:05 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014.043805.55513093.davem@redhat.com>
References: <20021014134047.R13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20021014134047.R13233@sunbeam.de.gnumonks.org>
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
   Date: Mon, 14 Oct 2002 13:40:47 +0200

   Pleae note that the bug was introduced in early 2.4.20-pre time, as newnat
   was merged.  So there's no need to worry about old (stable) kernel releases.
   
   Please apply the following fix, Thanks.

Applied.

I guess this means I really should push this stuff in for
2.4.20-preX
