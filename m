From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] netfilter unclean match extension
Date: Wed, 23 Oct 2002 04:03:14 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021023.040314.88793185.davem@redhat.com>
References: <20021022144050.GH3039@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20021022144050.GH3039@naboo.club.berlin.ccc.de>
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
   Date: Tue, 22 Oct 2002 16:40:50 +0200
   
   Exerpt from RFC 791: Various Control Flags.  Bit 0: reserved, must be zero

Just to be clear, if a future RFC or ietf working draft defines
meaning for this field, will we remove this new test from the
unclean module?
