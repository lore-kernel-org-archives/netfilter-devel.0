From: Patrick Schaaf <bof@bof.de>
Subject: Re: L2TP protocol source port number changed
Date: Thu, 22 May 2003 09:00:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030522070040.GD24297@oknodo.bof.de>
References: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw> <20030522055921.GA24297@oknodo.bof.de> <3ECC6D75.3000708@cobra.ee.ntu.edu.tw> <20030522063017.GC24297@oknodo.bof.de> <3ECC7235.9070606@cobra.ee.ntu.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ChungLiang <david@cobra.ee.ntu.edu.tw>
Content-Disposition: inline
In-Reply-To: <3ECC7235.9070606@cobra.ee.ntu.edu.tw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> 	Yes, that could be done in the rules one way or another. What I am
> wondering is that the rules are the same in both routers with same
> kernel version.

Do you have both working and nonworking routers available, and you can
reproduce both working and nonworking operations? Does a diff between
the two rulesets really show identical rules?

If I understand you correctly, the L2TP peers (your Windows box on
one end, something at the other) are one and the same in both setups?
You only vary the box in between?

Can you put a HUB between the Windows box and the working vs. nonworking
NAT router, and use a third box to sniff the traffic in both cases?

If that's all true, then you have a really interesting situation.
I have no idea what to make of it, and I cannot imagine, both kernels
being the same, that any amount of compile time options could help.

best regards
  Patrick
