From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Conntrack targets/matches work with nfconntrack
Date: Sat, 02 Apr 2005 23:42:33 +0200
Message-ID: <424F11C9.7010902@eurodev.net>
References: <424F0DD6.9070002@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <424F0DD6.9070002@eurodev.net>
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

Pablo Neira wrote:
> Hi,
> 
> This patch makes work conntrack related matches and targets with both 
> ip_conntrack and nf_conntrack (ipt_state, ipt_CONNMARK, ipt_connmark, 
> ipt_NOTRACK, ipt_conntrack). Two comments about this:

Forgot to say that this patch applies on top of latest Yasuyuki 
Kozakai's unification patches.

--
Pablo
