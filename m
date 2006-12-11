From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt and ipt_compat checks unification
Date: Mon, 11 Dec 2006 18:57:20 +0100
Message-ID: <457D9C00.9010401@trash.net>
References: <200612111648.02973.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200612111648.02973.dim@openvz.org>
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

Dmitry Mishin wrote:
> Matches and targets verification is duplicated in normal and compat processing
> ways. This patch refactors code in order to remove this.

Applied, thanks.
