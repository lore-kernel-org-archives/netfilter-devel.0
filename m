From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 01/15]: Add SANE connection tracking helper
Date: Thu, 08 Feb 2007 01:48:37 +0100
Message-ID: <45CA7365.1060909@trash.net>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
	<20070207082230.27478.24679.sendpatchset@localhost.localdomain>
	<Pine.LNX.4.61.0702080125390.32008@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0702080125390.32008@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Feb 7 2007 09:22, Patrick McHardy wrote:
> 
>>[NETFILTER]: Add SANE connection tracking helper
> 
> This [naming] is almost confusing to SAME. ipt_SAME, that is.
> 
> Though if you ask for a substitution, I have to pass up on that for the
> moment.

SAME is obsolete, and the name SANE comes from the same named
application/protocol that this helper is supposed to support.
Besided that, nobody is going to confuse helpers and targets
since the modules have a different naming scheme and people
generally don't care about target modules at all, they're
autoloaded and could for all that people care all be named
mod_foo.

I fail to see what you're trying to say.
