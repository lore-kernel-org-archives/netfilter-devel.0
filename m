From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Kernel Crash using iptables 1.3.4 and kernel 2.6.15
Date: Wed, 23 Nov 2005 16:26:31 +0100
Message-ID: <43848A27.3030705@eurodev.net>
References: <20051123134501.E418533BE2@crs.ultradns.net>
	<C2852E8C-7872-400B-951A-9D5C3B133C2D@iacookie.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: cookie <cookie@iacookie.net>
In-Reply-To: <C2852E8C-7872-400B-951A-9D5C3B133C2D@iacookie.net>
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

cookie wrote:
> Hello-
>   After upgrading my kernel to 2.6.15-rc2
> everything ran fine, then when I upgraded
> with iptables 1.3.4, I now get a mysterious
> system freeze.
>   About 1 in 10 times I get a message flashed
> to the console just before it dies.
> 
> barney kernel: skb_over_panic: text:00000000005b8ccc len:772 put:772 
> head:fffff80067b89400 data:fffff80067b89400 tail:fffff80067b89704 
> end:fffff80067b89700 dev:<NULL>
> 
> can anyone help me figure this message out?

Please, send the full oops message: that will help. Is that box running
a vanilla kernel or is it patched ?

-- 
Pablo
