From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: Re: trouble with expect_related
Date: 04 Jan 2003 04:34:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1041651291.1637.41.camel@exile>
References: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rich Wellner <netfilter@objenv.com>
In-Reply-To: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Rich,

On Sat, 2003-01-04 at 01:13, Rich Wellner wrote:
> I'm writing a module for ipfilters to deal with a protocol we use at work.
> You'll pardon me for being long winded, but I'm not positive what's going
> wrong.
> 
...
> 
> I claim it works because i see log messages and the helper is called as
> expected.
> 
> My problem is with the helper.  I parse the packet out and run
> ip_conntrack_expect_related but the incoming connection doesn't get passed
> through.  I have verified using tcpdump that the connection request does come
> from the remote machine, but my module doesn't seem to have registered the
> return right.  Anyway, here's the helper (more commentary follows code):
> 
...
>   ip_conntrack_expect_related(ct, &t, &mask, NULL);

FYI:
This is the "old" way of calling ip_conntrack_expect_related.
For quite a while now, there has been a newer infrastructure
for writing conntrack/nat helpers called "newnat". This
newer infrastructure solves some limitations of the old
code.

Since this newnat infrastructure was added to the mainline
kernel from early 2.4.20-pre releases onwards, and all the
netfilter conntrackers in CVS have been updated to this
infrastructure a long time ago, there really isn't much
interest in still using the old framework - all in all,
the newnat framework isn't that different if you're writing
a conntracker.

Have a look at the document describing newnat at:
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/documentation/newnat-summary.txt
(or check out netfilter CVS of course)
and check out some conntrackers to learn about the
new API:
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/extra/

The newnat patch that was included in the mainline kernel
for the 2.4.20 release and the patch can be found here:
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/submitted/z-newnat16.patch
Since you've already studied the ftp conntracking code,
you can see how ip_conntrack_expect_related is called a
little differently in ip_conntrack_ftp.c in the newnat 
infrastructure.

The documentation you based your work on has, as you
may have guessed, not been updated to represent these
changes yet.

However, the oldnat stuff you based your conntracker 
on should be able to add your expectations without
any problems, so your problem will probably not get
solved by moving to the newnat API.

...
> 
> Anyone capable of helping me will probably recognize the general structure of
> the above code as being that from the existing ftp/irc modules.  I tried to
> use the doc on netfilter.org, but it seems to be pretty outdated, making, for
> example, references to structure elements that don't exist anymore.
> 
> Significantly the last printk above shows what I expect to see: 
> Jan  3 17:45:54 oxygen kernel: expect_related 131.225.80.34:0-207.252.250.2:38344
> 
> but the incoming connection, as i say above, never makes it through.
> 
> I've tried several different variations, but would be willing to try more if
> people have only suggestions but no answers.  I'm just a bit out of my wits
> right now because the doc seems old and the many changes I've tried don't
> provoke any different behavior so I've not much to go on.  Frustrating.
> 

Are you also letting RELATED connections in ? Most often,
people will use

/usr/sbin/iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j
ACCEPT

It would be a "bang-your-head-against-the-wall" type of
mistake not to let RELATED traffic trough when writing a
conntracker.

Other than that, does 

cat /proc/net/ip_conntrack | grep ^EXPECTING

turn up anything ? It should if the expectation
is added and the firewall hasn't seen this traffic yet.

Regards,
Filip
