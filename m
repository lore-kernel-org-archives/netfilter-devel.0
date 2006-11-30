From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH IPTABLES 0/12]: matches/targets unification
Date: Thu, 30 Nov 2006 14:35:44 +0100
Message-ID: <456EDE30.4060108@trash.net>
References: <200611300943.kAU9hhUn013373@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611300943.kAU9hhUn013373@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> This patch series enables to unify matches/targets of ip[6]tables.
> 
> I've changed the only parts to unify register_{match,target} and
> moves duplicated functions to a file. Unfortunately, I had to change some
> arguments of the traditional APIs for them, but they are to avoid
> warning on compilation.
> 
> It might not be good time to submit this because of recent patch rush
> and it's just before next release of iptables, so it's just RFC this time.

Cool :) From a first look they all look good. I'll (try to) do a new
release as soon as I'm done with the nf_nat stuff so we can add this
quickly.
