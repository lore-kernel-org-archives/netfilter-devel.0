From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Missing owner-field initialization in iptable_raw
Date: Tue, 3 May 2005 14:22:31 -0700
Message-ID: <20050503142231.05b20c35.davem@davemloft.net>
References: <42768C63.2060104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42768C63.2060104@trash.net>
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

On Mon, 02 May 2005 22:24:03 +0200
Patrick McHardy <kaber@trash.net> wrote:

> table->owner must be initialized so module references can be taken
> by nf_queue().

Applied, thanks Patrick.
