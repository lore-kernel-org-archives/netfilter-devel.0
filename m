From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables trivial compile warning cleanup
Date: Mon, 03 Jul 2006 19:53:59 +0200
Message-ID: <44A959B7.8000309@trash.net>
References: <20060630205502.GA9243@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060630205502.GA9243@linuxace.com>
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

Phil Oester wrote:
> Cleanup a few compile warnings in latest snapshot:
> 
> extensions/libipt_dscp_helper.c:69: warning: 'dscp_to_name' defined but not used
> extensions/libipt_sctp.c: In function 'print_chunks':
> extensions/libipt_sctp.c:465: warning: value computed is not used
> extensions/libipt_sctp.c:477: warning: value computed is not used
> 
> Resolves bug #457.

Applied, thanks Phil.
