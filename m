From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] netfilter: optimization of
 ip_ct_selective_cleanup()
Date: Tue, 2 Dec 2003 01:44:37 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031202014437.056e53ba.davem@redhat.com>
References: <20031130153806.GH26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031130153806.GH26749@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 30 Nov 2003 21:08:06 +0530
Harald Welte <laforge@netfilter.org> wrote:

> Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> 
> Optimized ip_ct_selective_cleanup in order to avoid
> order n^2 lookup time of the whole conntrack hash.

It's always good to kill crap like this, patch applied.
