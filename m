From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Thu, 26 Feb 2004 21:24:24 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402262109050.12492-100000@filer.marasystems.com>
References: <000701c3fc81$ad0543d0$32640a0a@robopc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, rruegner <robowarp@gmx.de>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: RRuegner <robert@ruegner.org>
In-Reply-To: <000701c3fc81$ad0543d0$32640a0a@robopc>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Feb 2004, RRuegner wrote:

> i know your question, but where is the list which modules will fit to kernel
> 2.6.3, i have to setup a firewall machine and i wanna use 2.6.3 and want to
> know which newnat will compile clean at now.

The goal is to have most modules ported to 2.6 when pom-ng is released I
think. The current state is not yet ready for public consumtion on 2.6 as 
a lot porting efforts of the various extensions still remains.

> It would be nice to see a small info at the netfilter page about that.

Until it is ready for public consumtion there is little point in having 
such page I think.

And with pom-ng properly including dependency and kernel revision checks I
am not realy convinced such page is required. If you ask it will apply 
what can be applied to your kernel and tell what could not.

> Alltough i understood pom ng as a special redesign for the new kernel
> now i understand that this is only a redesign of pom.

Correct.

pom-ng is not a redesign for the new kernel, it is primary a redesign for
easier model of development and version management and at the same time
throwing in the ability to support multiple versions of the same extension
for different kernel versions.

The primary goal right now is to get pom-ng up to at least the same level
as pom is to make sure there is a stable foundation to work from allowing 
the developers to forget about pom.
  
Secondary goal is to port as many extensions as possible to also support
2.6 but this is actually a separate project, only made practically
possible by the introduction of pom-ng. So for the 2.6 porting activity to
get up to speed the pom-ng framework must first be verified.

Regards
Henrik
