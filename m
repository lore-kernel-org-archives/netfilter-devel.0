From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: latest pom: base/connlimit breaks kernel 2.4.25 compile (+possible
 fix)
Date: Mon, 12 Apr 2004 04:16:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404120355120.25631-100000@filer.marasystems.com>
References: <4079B1F2.8020007@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4079B1F2.8020007@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 11 Apr 2004, Friedrich Lobenstock wrote:

> > The development has fully switched over to pom-ng, and there will not be 
> > any new versions of the older pom published from what I can understand.
> 
> As far as I see there are still daily pom snapshots created so it
> can't be dead.

A cron job making daily snapshots does not make a tree alive.. developers 
working on a tree is the only thing which makes a tree alive.

> > pom-ng contains a superset of the extensions which was found in pom.
> 
> How about stability pom compared to pom-ng? It was "only" released the 
> first time in March, so I think for the time beeing I will have to stay 
> with good old "normal" pom.

pom-ng is the natural continuation of pom. It applies all the extensions
in the same manner, only that some of the extensions is newer and the
internal format of how patches/extensions is stored is very different.  
The majority of the pom-ng extensions is direct syntax translations from
their equivalent pom patches, and then improved upon. But yes the pom-ng
framework is still being worked upon to make it even more powerful, which
sometimes means there may be bugs in the framework.

For both pom and pom-ng stability of the resulting kernel is not 
guaranteed.

Netfilter pom (both styles) is just a "collection of patches" to the
Netfilter parts of the Linux kernel. Anything outside submitted (which btw
does not exists in pom-ng) is works in progress or otherwise not deemed
suitable for inclusion in the standard kernel and you should be careful
with what you use from there..  The base class of patches and extensions
is what the netfilter core team viewed as "probably useful for others" and
is what is primarily tested to build properly when there is new releases
of iptables or pom(-ng).


But yes, I agree that set should not be in base until the userspace
dependencies have been resolved. This should be in extra. It would
probably also do good to move userspace components from iptables to 
pom-ng.. (also applies to many other extensions living in both packages)

Regards
Henrik
