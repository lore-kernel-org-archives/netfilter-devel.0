From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resend [patch 2/2] iptables: add random option to SNAT
Date: Mon, 05 Feb 2007 16:06:01 +0100
Message-ID: <45C747D9.102@trash.net>
References: <1170681950.5631.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1170681950.5631.4.camel@localhost.localdomain>
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

Eric Leblond wrote:
> Hi,
> 
> This is a resend of :
> 	http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=36
> 
> Merge window for 2.6.21 is open and kernel part of the feature should
> reach kernel tree soon...


I'm in the process of preparing my patches for upstream submission
(which include your random patch). I'll look into the userspace patch
after that, I'm not a big fan of the :random syntax.
