From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] really fix ipt_state/ipt_conntrack refcounting
Date: Tue, 3 Feb 2004 09:15:04 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040203091504.72010e20.davem@redhat.com>
References: <20040203083231.GR24449@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040203083231.GR24449@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 3 Feb 2004 09:32:32 +0100
Harald Welte <laforge@netfilter.org> wrote:

> Further investigation led to the discovery that explicit manual
> refcounting is not needed anymore and is rather a historic relict.
> 
> The attached patch removes all manual explicit refcounting.
> 
> Please apply (on top of the previous one).

Applied, thanks Harald.
