From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: 05 Apr 2003 13:16:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049541403.25169.167.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304041041450.18961-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304041041450.18961-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-04-04 at 10:46, Jozsef Kadlecsik wrote:

> I have just updated the runme script in patch-o-matic:
> 
> - removed copying the source trees at patch testing (faster processing)

Gives a quite nice speedup :)

> - added patch-dependency support

This is very nice.

But do we really want to check dependencies in reverse mode?

Say I have patches B and C which both depends on patch A.
I patch in B and A is automagically applied, then I apply C.
Then I reverse B or C and as a result A is also backed out, oops.

    # Check the dependecy of the patch
    if [ -f "$1.depend" ]; then

should probably be

    # Check the dependecy of the patch
    if [ -f "$1.depend" -a -z "$MODE" ]; then

which also makes some of the code below redundant.

I've tested this and it works fine.
(changed both the testing and applying)

If that's ok with you I'll commit it together with my changes that adds
support for conflicting patches as well. just add "not " first on the
line in the .depend file.

so tcp-window-tracking.patch.depend would look like:

not extra/ip_conntrack-timeouts.patch

And if ip_conntrack-timeouts.patch already is applied you get this
output:

Patch extra/tcp-window-tracking.patch conflicts with extra/ip_conntrack-timeouts.patch...
ip_conntrack-timeouts.patch ALREADY APPLIED (0 rejects out of 10 hunks).

Conflicting dependency.
   extra/tcp-window-tracking.patch
is incompatible with
   extra/ip_conntrack-timeouts.patch

and it stops.

It skips empty lines and lines beginning with # in the .depend files

I've also added a check if we are using force in apply_patch_depend()
and if we are deps won't be checked.

I've tested my changes with various dependencies and conflicts and it
seems to work.

> > tcp-window-tracking.patch should soon be updated in cvs to reflect the
> > changes.
> 
> I'll update the tcp-window-tracking patch around the end of the next week.
> I want to test the new version in production before releasing it.

Ok, I just updated the current version to apply after
pending/24_conntrack-nosysctl.patch has been applied.

-- 
/Martin
