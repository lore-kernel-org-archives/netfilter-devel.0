From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ctnetlink: Fix NAT info setting.
Date: Sun, 04 Dec 2005 16:36:31 +0100
Message-ID: <43930CFF.5030301@trash.net>
References: <438EEF0E.60206@ingate.com> <438EF925.4050802@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Marcus Sundberg <marcus@ingate.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <438EF925.4050802@eurodev.net>
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
> [NETFILTER] ip_nat_initialized takes wrong parameter
> 
> ip_nat_initialized() takes enum ip_nat_manip_type as it's second
> argument, not a hook number.

Applied, thanks Pablo and Marcus.
