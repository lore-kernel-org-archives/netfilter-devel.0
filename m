From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] netfilter: export conntrack bucket count via sysctl
Date: Tue, 2 Dec 2003 01:46:14 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031202014614.26dbae1f.davem@redhat.com>
References: <20031130154006.GI26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031130154006.GI26749@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 30 Nov 2003 21:10:06 +0530
Harald Welte <laforge@netfilter.org> wrote:

> Author: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
> 
> This creates a new (read-only) sysctl to read out the number of hash buckets.

Applied, thanks.
