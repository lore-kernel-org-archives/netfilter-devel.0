From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 03/05]: nf_conntrack: move conntrack protocol sysctls
 to individual modules
Date: Mon, 27 Nov 2006 11:32:26 +0100
Message-ID: <456ABEBA.6030800@trash.net>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>	<20061126144451.4215.77390.sendpatchset@localhost.localdomain>
	<200611270527.kAR5RLHM003180@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611270527.kAR5RLHM003180@toshiba.co.jp>
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
>>+#ifdef CONFIG_SYSCTL
>>+static unsigned int tcp_syctl_table_users;
> 
> 
> tcp_sysctl_table_users ? (second 's' is missing)

Fixed, thanks :)
