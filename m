From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH/RFC] core/netfilter.c: possible use of freed skb
Date: Sun, 27 Jul 2003 15:50:30 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030727155030.2ce4e22e.davem@redhat.com>
References: <200307271655.15937.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200307271655.15937.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 27 Jul 2003 16:55:15 +0200
Bart De Schuymer <bdschuym@pandora.be> wrote:

> In nf_reinject(), info->okfn(skb) is called when the verdict is NF_ACCEPT.
> This okfn deals with the skb and is responsible for freeing the skb.
> Unfortunately the current code in nf_reinject() still uses this possibly
> freed skb.
> The patch below fixes this without introducing any new code.

This patch looks OK to me, can I get an ACK from the
netfilter folks?
