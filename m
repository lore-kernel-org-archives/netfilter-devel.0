From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] clear nf_debug in ipsec tunnel case
Date: Thu, 11 Sep 2003 16:38:27 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030911163827.7115e86e.davem@redhat.com>
References: <20030905121955.GH665@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030905121955.GH665@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Sep 2003 14:19:55 +0200
Harald Welte <laforge@netfilter.org> wrote:

> This patch (again by Patrick McHardy) clears nf_debug in
> ip_local_deliver_finish so the "hook ... already set" message in
> nf_hook_slow won't get triggered for decapsulated ipsec-tunnel packets
> when passing them through the network stack again.

Applied, thanks.
