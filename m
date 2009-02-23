From: Robby Workman <rw@rlworkman.net>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.11 released
Date: Mon, 23 Feb 2009 09:34:16 -0600
Message-ID: <20090223093416.2c63fc02@liberty.rlwhome.lan>
References: <49A03C73.8010004@netfilter.org>
	<20090222233433.0dc8f396@liberty.rlwhome.lan>
	<alpine.LSU.2.00.0902230815570.20446@fbirervta.pbzchgretzou.qr>
	<49A26A3E.5020707@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49A26A3E.5020707@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 23 Feb 2009 10:19:58 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Jan Engelhardt wrote:
> > On Monday 2009-02-23 06:34, Robby Workman wrote:
> >> On Sat, 21 Feb 2009 18:40:03 +0100
> >> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >>> The netfilter project presents another development release of the
> >>> conntrack-tools...
> >> I thought I recalled seeing discussion about this already, but I
> >> don't see it in my archives, so maybe not.   With glibc-2.7, this
> >> release builds fine; however, with glibc-2.9, both src/mcast.c and
> >> src/sync-mode.c need limits.h included, or else INT_MAX is
> >> undefined.
> > 
> > This builds fine for me - and I am on glibc 2.9.
> > Just *what* is it in (which distro? Debian/Ubuntu again?)
> > again to constantly fail on INT_MAX?
> 
> Indeed. This also compiles fine for me in debian. I have committed a
> patch for this [1]. This issue is unfortunate. Gentoo bugzilla on
> conntrack-tools had a patch but nobody has sent it to me. I notice it
> after the release.
> 
> [1]
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=9bf002ff7935e7dff625683787fc3a06ac2ef2cb


Weird that it's not affecting Jan then, because it's definitely
something specific to newer glibc (or perhaps gcc, but it's not
immediately obvious how that would be the case). I'm on Slackware 
rather than Gentoo, running quite a bit of prerelease development 
builds (including gcc-4.3.3 and glibc-2.9 along with 2.6.28.7 kernel).

-RW
