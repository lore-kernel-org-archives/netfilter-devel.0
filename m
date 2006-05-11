From: Philip Craig <philipc@snapgear.com>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 18:58:42 +1000
Message-ID: <4462FCC2.90205@snapgear.com>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>	<4462E031.4090206@trash.net>
	<20060511082555.GB10324@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060511082555.GB10324@sunbeam.de.gnumonks.org>
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

On 05/11/2006 06:25 PM, Harald Welte wrote:
> I agree, I prefer automatic fallback while giving the user the ability
> to unload.  However, if people automatically unload 'unused' modules,
> then there might be a problem (however, for both ULOG and nfnetlink_log,
> userspace listeners would increment the refcount, I think).

What constitutes in use?  If a backend is in use whenever it is
the highest priority backend, then blocking unloading would mean
nfnetlink_log can never be unloaded.  Letting the user choose the
highest priority backend would solve that.  In which case I think
blocking unloading is desirable, we shouldn't unload the backend
the user has chosen.

And I assume that log rules can also specify a backend? (eg the
LOG and ULOG rules always will)  That should probably block
unloading too.

> Also, there is another unresolved problem:  What if we actually have
> e.g. nfnetlink_log loaded, but it is unable to send a specific packet to
> userspace because there is no listener for this Address family or log
> group?   Should we then also fall back on some other backend?

Just doing a printk to notify of the error is enough?
We probably should be doing a printk anyway if it is
a backend the user has chosen explicitly.
