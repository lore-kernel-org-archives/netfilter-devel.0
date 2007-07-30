From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][CTNETLINK] return EEXIST instead of EINVAL for existing
 nat'ed conntracks
Date: Mon, 30 Jul 2007 14:34:56 +0200
Message-ID: <46ADDAF0.8030008@trash.net>
References: <46A8A177.7020205@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A8A177.7020205@netfilter.org>
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

Pablo Neira Ayuso wrote:
> ctnetlink must return EEXIST for existing nat'ed conntracks instead of
> EINVAL. Only return EINVAL if we try to update a conntrack with NAT
> handlings (that is not allowed).


Applied, thanks Pablo.
