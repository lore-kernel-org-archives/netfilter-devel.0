From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] fix problem with netfilter compat code removal
Date: Wed, 16 Apr 2003 10:43:45 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030416.104345.103615702.davem@redhat.com>
References: <1050501636.30792.50.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gandalf@wlug.westbo.se
In-Reply-To: <1050501636.30792.50.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Martin Josefsson <gandalf@wlug.westbo.se>
   Date: 16 Apr 2003 16:00:37 +0200

   Here's a fix for 2.4, the netfilter compat code removal forgot to remove
   one instance of 'reset'. Doesn't compile without this fix.
   
   Please apply to 2.4 (it's ok in 2.5)

Applied, thanks Martin.
