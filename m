From: "Gonzalo A. Arana" <garana@uolsinectis.com.ar>
Subject: Re: iptables as a state machine
Date: Fri, 1 Oct 2004 17:06:14 -0300
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001170614.62da9ef7@garana.hq.sinectis.com.ar>
References: <20040930193955.6fa24afc.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040930193955.6fa24afc.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Content-Transfer-Encoding: 7bit


On Thu, 30 Sep 2004 19:39:55 -0700
"David S. Miller" <davem@davemloft.net> wrote:

> 
> So while waiting for a kernel build to finish I was sniffing
> around the iptables code thinking about how one might optimize
> the lookups.
> 
> The ipt targets are simple enough already, and I think this
> shows the elegance of the core iptables design.
> 
> It's the main ip header + indev + outdev matching that is
> the real memory and cpu cycle killer in these paths.  Once
> we match the target, the verdict is determined quickly.

Are you trying to optimize a single rule matching?  Or the traveral of an entire chain?

> ...
