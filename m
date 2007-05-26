From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: ip6_tables: Fixes explanation of valid upper protocol
 number
Date: Sat, 26 May 2007 15:44:05 +0200
Message-ID: <465839A5.7080805@trash.net>
References: <200705250810.l4P8A2DL002869@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705250810.l4P8A2DL002869@toshiba.co.jp>
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
> This explains the allowed upper protocol numbers. IP6T_F_NOPROTO was
> introduced to use 0 as Hop-by-Hop option header, not wildcard. But that
> seemed to be forgotten. 0 has been used as wildcard since 2002-08-23.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki@netfilter.org>

Queued for 2.6.23, thanks Yasuyuki.
