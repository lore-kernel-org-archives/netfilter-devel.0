From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH][RESEND] libip6t_hl.c
Date: 07 May 2003 22:08:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1052338131.23434.19.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.51.0305072102490.18682@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0305072102490.18682@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-05-07 at 21:03, Maciej Soltysiak wrote:
> [there was no response on this]
> 
> Hello,
> 
> Stephane Ouellette has sent me a patch to the libip6t_hl.c module
> to make some cleanups. Here's the list of changes:
> 1- help() now indicates that the reverse match is supported.
> 2- final_check() was missing a single-quote.
> 3- C99 initializers
> 4- Simplify print() and save() to reduce the number of calls to printf().
> 
> Please apply.

Applied thanks.

-- 
/Martin
