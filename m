From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3]  [RFC] fixed duration connection
Date: Wed, 05 Apr 2006 15:57:19 +0200
Message-ID: <4433CCBF.6060103@trash.net>
References: <1144139619.5186.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1144139619.5186.24.camel@localhost.localdomain>
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
> While working on NuFW development branch, we have had to
> implement policy just as :
>       * connection to server is authorised from 08h to 18h and
>         connection must be switched off at 18h.
> 
> Such features are frequently asked by customers or netfilter addicts but
> even with current conntrack related code, it can not be done cleanly.
> 
> Thus, we've added the notion of fixed duration before expiration to
> connection in the conntrack. (See extended information on bottom for
> details)
> 
> The following set of patches is against kernel (linus git tree),
> libnetfilter_conntrack, and conntrack tool.
> 
> -- Extended --
> 
> When trying to implement this feature with current connection tracking
> code, we have faced some issues :
>      1. userspace code has to duplicate conntrack entries, thus it's
>         complex and uses memory
>      2. there is no hope to have it done by a simple command line
>         (because of 1.)
>      3. if replication of conntrack in userspace is needed there will be
>         many synchronisation problems : stop and start of an
>         hypothetical "expiration" daemon would cause conntrack
>         duplication and/or loss of information ...
> 
> For this reason, we've worked on a simple kernel level implementation.
> This is done via a second "struct timer" that is added in connection
> structure. Activation of the timer, is for now done via userspace by
> using libnetfilter_conntrack or by using new option -T of the conntrack
> tool.

If I understand you correctly, a fixed timeout is just a timeout that
isn't refreshed, right? Why can't we just use the regular timers etc.
and add a flag that it should not be touched by ip_ct_refresh? This
would also eliminate the need for any ctnetlink changes since the
timeout value can already be specified.
