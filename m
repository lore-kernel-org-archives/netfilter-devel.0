From: Pablo Neira <pablo@eurodev.net>
Subject: Re: how to install time patch
Date: Thu, 17 Nov 2005 14:12:15 +0100
Message-ID: <437C81AF.4080806@eurodev.net>
References: <20051117130231.81944.qmail@web53610.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, mail@epfi.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: manish popli <popli_manish77@yahoo.com>
In-Reply-To: <20051117130231.81944.qmail@web53610.mail.yahoo.com>
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

manish popli wrote:
> No it hasn't /proc/net/ip_tables_matches interface
> but there is /proc/net/ip_mr_cache &
> /proc/net/ip_mr_vif
> can you tell me how to upgrade kernal ??

1) Checkout a working copy of pom-ng:
$ svn co https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng

2) cd trunk/patch-o-matic-ng and ./runme
Then apply the time patch, you need the kernel and iptables sources
(Yes, you have to recompile your kernel and iptables)
You'll have to set IPTABLES_DIR and KERNEL_DIR vars to whatever your
sources are located.

I suggest you to post this kind of questions to
netfilter@lists.netfilter.org (users mailling list). Since this is no
concerned with the netfilter development. Thanks!

-- 
Pablo
