From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] netfilter unclean match extension
Date: Wed, 23 Oct 2002 04:25:04 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021023.042504.24890238.davem@redhat.com>
References: <20021023.040314.88793185.davem@redhat.com>
	<Pine.LNX.4.44.0210231323200.20094-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@gnumonks.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: solt@dns.toxicfilms.tv
In-Reply-To: <Pine.LNX.4.44.0210231323200.20094-100000@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
   Date: Wed, 23 Oct 2002 13:26:05 +0200 (CEST)

   > Just to be clear, if a future RFC or ietf working draft defines
   > meaning for this field, will we remove this new test from the
   > unclean module?

   Then, we should update the match to remove the test as it may render some
   routers inoperational for some data streams, vide the ECN issue.

I read rfc 791 and 793 some more.

The difference here is that for the ECN bits it says
"reserved for future use", whereas for this one flag bit
it says just "reserved".

Ok, I'm convinced :-)
