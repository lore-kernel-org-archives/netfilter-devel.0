From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Tue, 29 Apr 2003 19:26:21 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429.192621.71114474.davem@redhat.com>
References: <20030428123009.4cde1e57.shemminger@osdl.org>
	<20030429.012909.26514398.davem@redhat.com>
	<20030429115845.45e48dfa.shemminger@osdl.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: shemminger@osdl.org
In-Reply-To: <20030429115845.45e48dfa.shemminger@osdl.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Stephen Hemminger <shemminger@osdl.org>
   Date: Tue, 29 Apr 2003 11:58:45 -0700

   On Tue, 29 Apr 2003 01:29:09 -0700 (PDT)
   "David S. Miller" <davem@redhat.com> wrote:
   
   > Applied, thanks.
   
   Looks like one line got dropped in the patch.
   
Unused local var, GCC gave a warning, so I deleted it.
