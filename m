From: Harald Welte <laforge@netfilter.org>
Subject: Re: Multicast & iptables
Date: Thu, 22 Jul 2004 19:57:10 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040722235709.GT27487@obroa-skai.de.gnumonks.org>
References: <62095.217.169.232.210.1089106503.squirrel@hupie.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ferry Huberts <ferry@hupie.com>
Content-Disposition: inline
In-Reply-To: <62095.217.169.232.210.1089106503.squirrel@hupie.xs4all.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 06, 2004 at 11:35:03AM +0200, Ferry Huberts wrote:
> Hello guys & gals

as connection tracking doesn't support multicast, iptable_nat doesn't
support multicast either.

-- 
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
