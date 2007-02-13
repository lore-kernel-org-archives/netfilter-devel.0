From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net/netfilter/xt_tables: Remove duplicate of xt_prefix
Date: Tue, 13 Feb 2007 12:40:53 +0100
Message-ID: <45D1A3C5.9010707@trash.net>
References: <20070126130714.GA28541@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070126130714.GA28541@distanz.ch>
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

Tobias Klauser wrote:
> Remove xt_proto_prefix array which duplicates xt_prefix and change all
> users of xt_proto_prefix to xt_prefix.

Applied, thanks.
