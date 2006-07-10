From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: handle cidr notation more sanely
Date: Mon, 10 Jul 2006 06:26:38 +0200
Message-ID: <44B1D6FE.6080208@trash.net>
References: <20060709222818.GA23200@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060709222818.GA23200@linuxace.com>
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
> At present, a command such as
> 
> 	iptables -A foo -s 10.10/16
> 
> will interpret 10.10/16 as 10.0.0.10/16, and after applying the mask end
> up with 10.0.0.0/16, which likely isn't what the user intended.  Yet
> some people do expect 10.10 (without the cidr notation) to end up as
> 10.0.0.10.
> 
> The below patch should satisfy all parties.  It zero pads the missing
> octets only in the cidr case, leaving the IP untouched otherwise.
> 
> This resolves bug #422

Applied, thanks Phil. Hope all those lazy typers are happy now :)
