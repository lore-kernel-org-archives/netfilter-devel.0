From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/04]: nf_nat_proto_gre: do not modify/corrupt
 GREv0 packets through NAT
Date: Thu, 03 May 2007 03:34:59 -0700 (PDT)
Message-ID: <20070503.033459.75756192.davem@davemloft.net>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
	<20070503012440.12818.75627.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012440.12818.75627.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu,  3 May 2007 03:25:59 +0200 (MEST)

> [NETFILTER]: nf_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT
> 
> While porting some changes of the 2.6.21-rc7 pptp/proto_gre conntrack
> and nat modules to a 2.4.32 kernel I noticed that the gre_key function
> returns a wrong pointer to the GRE key of a version 0 packet thus
> corrupting the packet payload.
> 
> The intended behaviour for GREv0 packets is to act like
> nf_conntrack_proto_generic/nf_nat_proto_unknown so I have ripped the
> offending functions (not used anymore) and modified the
> nf_nat_proto_gre modules to not touch version 0 (non PPTP) packets.
> 
> Signed-off-by: Jorge Boncompte <jorge@dti2.net>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
