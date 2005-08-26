From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 08:16:55 -0700
Message-ID: <20050826151655.GA5606@linuxace.com>
References: <20050826111832.GT4226@rama.de.gnumonks.org>
	<430F007B.20605@trash.net>
	<20050826131901.GY4226@rama.de.gnumonks.org>
	<430F1C07.5020305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <430F1C07.5020305@trash.net>
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

On Fri, Aug 26, 2005 at 03:41:27PM +0200, Patrick McHardy wrote:
> Sure :) I just think its nicer than to enable "sub-functionality" by
> config options, so if its there, its usable. I also don't think there
> are people who actually have CONFIG_EXPERIMENTAL disabled, so in
> the end, we just save a few ifdefs in the code.

Agree that almost everyone enables CONFIG_EXPERIMENTAL.  How about 
an IP_NF_TARGET_TTL_DEC which depends on IP_NF_TARGET_TTL, and which
has a nice big warning about being dangerous?

Phil
