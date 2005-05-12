From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng 4/6] H.323: splitted ip_conntrack_h323.c into 3
	sources
Date: Thu, 12 May 2005 07:26:04 +0200
Message-ID: <20050512052604.GA18421@roonstrasse.net>
References: <20050510225019.GA5102@roonstrasse.net>
	<20050510225255.GD5720@roonstrasse.net>
	<428297FE.1040900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <428297FE.1040900@trash.net>
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

On 2005/05/12 01:40, Patrick McHardy <kaber@trash.net> wrote:
> Max Kellermann wrote:
> > h323-04-split_conntrack_into_3.patch
> > - splitted ip_conntrack_h323.c into 3 sources
> > 
> > diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c
> > --- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c	1970-01-01 01:00:00.000000000 +0100
> > +++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c	2005-05-10 23:33:19.000000000 +0200
> 
> This file looks a bit unnecessary, I suggest to put register/unregister
> in ip_conntrack_h323_h225.c.

I splitted the file because it became very large (I dislike sources >
500 lines). I decided to make a _core.c because this way, the _h225.c
and _h245.c contain only protocol parser code, and nothing else -
still having the option to add more "common" code to _core.c (whatever
happens in further development).

In the compiled binary, there is no advantage of merging _core and
_h225.c.

A matter of personal taste. If you vote me down on this one, I'll
change it.

Max
