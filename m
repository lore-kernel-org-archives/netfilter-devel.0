From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] conntrack tool: Fix loading of protocol helpers
Date: Fri, 16 Mar 2007 17:59:37 +0100
Message-ID: <45FACCF9.5060201@trash.net>
References: <200703161751.08498.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703161751.08498.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> Hello,
> 
> the pkgconfig changes from August 2006 broke the loading of the protocol 
> helpers as dlopen() doesn't search for symbols in the main executable.
> As a result the protocol helpers can't find register_proto().
> 
> Attached patch fixes the problem.

Applied, thanks again Thomas.

> Does anyone have a short example how to use the -G functionality of the tool?

Not out of my head, sorry.
