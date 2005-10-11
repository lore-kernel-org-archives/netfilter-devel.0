From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 15:32:57 -0700 (PDT)
Message-ID: <20051011.153257.75932845.davem@davemloft.net>
References: <20051011104446.GJ4290@rama>
	<20051011175457.GC13415@rama.de.gnumonks.org>
	<434C3485.2000700@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	bdschuym@pandora.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: seb@frankengul.org
In-Reply-To: <434C3485.2000700@frankengul.org>
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

From: S=E9bastien Bernard <seb@frankengul.org>
Date: Tue, 11 Oct 2005 23:54:13 +0200

> On sparc64, cpu_possible_map does not exist.

Yes, it does, although indirectly.  Otherwise for_each_cpu() would be
horrible broken and never allow building sparc64 SMP kernels :-)

It's defined in kernel/sched.c for non-SMP and defined to
phys_cpu_present_map when SMP.

Did you try to build his patch and it actually failed?  If so, please
post the build failure instead of speculation about why it failed so
that this can be properly analyzed :-)
