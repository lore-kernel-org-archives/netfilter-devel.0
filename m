From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] Fix ipt_REJECT if used on bridge
Date: Sun, 24 Aug 2003 04:46:01 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824044601.7b6a30a6.davem@redhat.com>
References: <20030823204612.GB5107@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030823204612.GB5107@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 23 Aug 2003 22:46:12 +0200
Harald Welte <laforge@netfilter.org> wrote:

> The patch below (courtesy of Bart de Schuymer) fixes an issue
> (skb->nf_bridge not initialized after skb_copy) with briging in the case
> of ipt_REJECT is used on a filtering bridge.
> 
> Please apply, thanks!

Ignore my previous email about this patch not applying,
I did something stupid when saving the email into a file
for applying :-)

Applied, thanks.
