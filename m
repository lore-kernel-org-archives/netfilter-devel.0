From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix locking in ip_conntrack_change_expect()
Date: Mon, 14 Oct 2002 07:00:59 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014.070059.53435542.davem@redhat.com>
References: <20021014134047.R13233@sunbeam.de.gnumonks.org>
	<20021014.043805.55513093.davem@redhat.com>
	<20021014160309.Z13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20021014160309.Z13233@sunbeam.de.gnumonks.org>
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
   Date: Mon, 14 Oct 2002 16:03:09 +0200

   On Mon, Oct 14, 2002 at 04:38:05AM -0700, David Miller wrote:
   
   > I guess this means I really should push this stuff in for
   > 2.4.20-preX
   
   yes, this is the only one which should be submitted before 2.4.20-final.

There were two locking fixes Harald :-)

What I want to push to Marcelo is:

1) Avoid nesting readlocks in conntrack
2) Fix ip_conntrack_change_expect locking
3) Display ipv6 SIT encapsulation properly

Ok?
