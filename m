From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] [NF_CONNTRACK] load on demand layer 3 protocol
	handlers
Date: Sat, 04 Mar 2006 10:35:03 +0100
Message-ID: <44095F47.3070804@trash.net>
References: <44025FAE.1000400@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44025FAE.1000400@netfilter.org>
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
> x_tables matches and targets that require nf_conntrack_ipv[4|6] to work
> don't have enough information to load on demand these modules. This
> patch introduces the following changes to solve this issue:

All other patches also applied to 2.6.17. Thanks especially for 4/5, I
was too lazy to do it myself :)
