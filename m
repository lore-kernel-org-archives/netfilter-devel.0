From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] fix ECN target / cloned skb problem
Date: Fri, 20 Feb 2004 15:10:55 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220151055.55af3651.davem@redhat.com>
References: <20040220200106.GN4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20040220200106.GN4797@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004 21:01:06 +0100
Harald Welte <laforge@gnumonks.org> wrote:

> The attached patch fixes a 2.4-only problem in the ECN target - we miss
> to re-set some pointers after uncloning the skb.
> 
> Thanks to Maciej Soltysiak for spotting that problem and preparing the
> patch.

Applied, thanks.
