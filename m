From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] xt_gateway match (kernel,2)
Date: Sat, 2 Jun 2007 19:08:22 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706021906290.5076@yvahk01.tjqt.qr>
References: <46604D8B.7030507@ufomechanic.net>
	<Pine.LNX.4.61.0706021337370.21057@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706021856200.5076@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706021856200.5076@yvahk01.tjqt.qr>
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

On Jun 2 2007 18:56, Jan Engelhardt wrote:
>---
> include/linux/netfilter/xt_gateway.h |   13 +++++
> net/netfilter/Kconfig                |    9 +++
> net/netfilter/Makefile               |    1 
> net/netfilter/xt_gateway.c           |   85 +++++++++++++++++++++++++++++++++++
> 4 files changed, 108 insertions(+)

A MODULE_ALIAS was missing, causing iptables/netfilter not to autoload 
the module.
SVN tree¹ updated (grab the refreshed patch from there, not reposting 
for this minimal change).


	Jan
-- 
[¹] https://dev.computergmbh.de/svn/misc_kernel/xt_gateway/trunk/
