From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Tue, 29 Apr 2003 01:26:30 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429.012630.27801614.davem@redhat.com>
References: <20030427132413.GP990@sunbeam.de.gnumonks.org>
	<20030428062622.5F0FE2C4D3@lists.samba.org>
	<20030428102307.0d2718d3.shemminger@osdl.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: shemminger@osdl.org
In-Reply-To: <20030428102307.0d2718d3.shemminger@osdl.org>
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
   Date: Mon, 28 Apr 2003 10:23:07 -0700

   Addition to Rusty's patch that uses C99 initializers for the 
   Netfilter Ethernet bridge routing hooks table.
   
   Dave if you apply Rusty's for the queue/module/reinject race then
   please apply this.
   
Applied, thanks.
