From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] netfilter unclean match extension
Date: Wed, 23 Oct 2002 04:21:33 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021023.042133.31968435.davem@redhat.com>
References: <20021022144050.GH3039@naboo.club.berlin.ccc.de>
	<20021023.040314.88793185.davem@redhat.com>
	<20021023132248.E2450@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20021023132248.E2450@sunbeam.de.gnumonks.org>
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
   Date: Wed, 23 Oct 2002 13:22:48 +0200
   
   yes, we will.  But right now the RFC doesn't only say 'reserved for future
   use', but says 'must be zero'.
   
   IIRC, this is different from the ECN case.

Look at the TCP RFC, 793, on page 15 it says:

Reserved: 6 biits

  Reserved for future use.  Must be zero.

So this is precisely like the ECN case.
