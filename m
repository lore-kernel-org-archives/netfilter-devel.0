From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] libipt_osf: fix iptables-1.3.0rc1 compilation.
Date: Mon, 7 Feb 2005 22:40:28 +0300
Message-ID: <20050207224028.07521aa6@zanzibar.2ka.mipt.ru>
References: <1107797393.5789.17.camel@uganda>
	<20050207182039.GI10011@obroa-skai.de.gnumonks.org>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050207182039.GI10011@obroa-skai.de.gnumonks.org>
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

On Mon, 7 Feb 2005 19:20:39 +0100
Harald Welte <laforge@netfilter.org> wrote:

> On Mon, Feb 07, 2005 at 08:29:53PM +0300, Evgeniy Polyakov wrote:
> > Bug reported by Sami Farin <safari-kernel@safari.iki.fi>.
> > 
> > Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> Erm, this is not a libipt_osf.c fix, but a ipt_osf.h fix.  And ipt_osf.h
> is not part of the iptables-1.3.0rc1 package at all.
> 
> Please clarify, thanks.

It was triggered by userspace libipt_osf compilation, 
which is part of iptables package, that is why I called it libipt_osf.c 
fix(userspace should not include kernel headers directly).

> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
> 


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
