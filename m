From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Sun, 12 Jun 2005 15:38:14 +0200
Message-ID: <42AC3AC6.4080304@trash.net>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
	<42AB0D81.2080804@trash.net>
	<20050612095655.GB19830@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050612095655.GB19830@obroa-skai.de.gnumonks.org>
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

Harald Welte wrote:
> It seems fine to me, but we alwasy need to be cautious with silently
> changing semantics that people might rely on...  
> 
> but please apply...

Thanks for your feedback. Charlie, your patch doesn't apply, apparently
because of whitespace issues:

patching file ip6tables-restore.c
Hunk #1 FAILED at 233.
1 out of 1 hunk FAILED -- saving rejects to file ip6tables-restore.c.rej
patching file iptables-restore.c
Hunk #1 FAILED at 236.
1 out of 1 hunk FAILED -- saving rejects to file iptables-restore.c.rej

Please resend as attachment.

Regards
Patrick
