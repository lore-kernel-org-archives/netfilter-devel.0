From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Don't increase master refcount on expectations
Date: Sun, 04 Sep 2005 19:47:43 +0200
Message-ID: <431B333F.8030902@trash.net>
References: <430E2DF9.8060802@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <430E2DF9.8060802@eurodev.net>
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
> As it's been discussed [1][2]. We shouldn't increase the master 
> conntrack refcount for non-fulfilled conntracks. During the conntrack 
> destruction, the expectations are always killed before the conntrack 
> itself, this guarantees that there won't be any orphan expectation.

Applied, thanks. Is it correct that this also fixes the untriggerable
deadlock Yasuyuki noticed?
