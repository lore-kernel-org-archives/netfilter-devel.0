From: Brad Fisher <brad@info-link.net>
Subject: rfc on new match type
Date: Wed, 07 May 2003 17:29:12 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EB988B8.707B6111@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've been thinking that it may be nice to have a match which can be used
to identify which application added a particular rule.  For example, if
there is an application (say "fwadminprogram") which adds rules it could
mark those rules with an id of some sort using this match.  Perhaps
something like:

  iptables -A <chain> -m application --application-id 2000 <other params
here>

So the application could determine which rules it added by searching for
all rules with an "application" match with the id 2000.  On the kernel
side, the match would not actually do anything, it would just match the
packet.

The main purpose of this (at least as i see it) would be to have a way
to ignore rules not added by your application, so you don't have to
worry (as much) about messing up what other applications may have set
up.  Or perhaps the application-id could be a string instead of an
integer, thus allowing you to mark the rules with the application name
instead.

I'll probably end up implementing this match sometime in the near future
for a project i'm working on.  Unless of course, someone has a better
idea?  Maybe it's already possible to do this with an existing match?

Anyway, just thought I'd see what others thought.

Brad Fisher
Info Link Inc.
