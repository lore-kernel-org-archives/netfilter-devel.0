From: Patrick Schaaf <bof@bof.de>
Subject: Re: IP Queue and fragmentation
Date: Fri, 14 Feb 2003 09:51:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030214085140.GB7631@oknodo.bof.de>
References: <C3F7A1AD0781F84784B5528466CA09DD04F4E0@megisto-sql1> <20030214084448.GA7631@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manickavel Subramaniraj <MSubramaniraj@MEGISTO.com>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030214084448.GA7631@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> As an example of how to gather the fragments, grep for skb_linearize
> in net/ipv4/netfilter/ip_conntrack_core.c. When conntracking is active,
> all packets will be defragmented by the kernel. All the nat functionality
> is implemented with the assumption of defragmented packets, that's why
> it is done that way.

Sorry, I was confused. The operational description is correct, but the
thing to grep for, is the function ip_ct_gather_frags(). skb_linearize()
concerns itself with single packets being represented by a scatter/gather,
and the linearization of that list. ip_ct_gather_frags() is used to reassemble
fragments.

best regards
  Patrick
