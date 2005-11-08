From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Add parse_inetaddr and replace inet_addr by
	parse_inetaddr
Date: Tue, 08 Nov 2005 03:01:23 +0100
Message-ID: <437006F3.9020508@eurodev.net>
References: <Pine.LNX.4.64.0511062049530.29353@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511062049530.29353@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Conntrack-tool should always notify user about invalid address and
> assuming INADDR_NONE, which usually is -1 (255.255.255.255) is not the
> right way of handling typos.

Applied, thanks.

-- 
Pablo
