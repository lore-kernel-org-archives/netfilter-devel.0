From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Sun, 12 Jan 2003 13:11:51 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15905.55831.492080.943865@isis.cs3-inc.com>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com>
	<20030106125720.GF9467@sunbeam.de.gnumonks.org>
	<15897.46884.822054.847738@isis.cs3-inc.com>
	<20030107185748.GV9467@sunbeam.de.gnumonks.org>
	<15899.51201.381520.438520@isis.cs3-inc.com>
	<20030108105646.GH9467@sunbeam.de.gnumonks.org>
	<15900.41422.812422.110502@isis.cs3-inc.com>
	<20030111194740.GF24488@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030111194740.GF24488@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

(reshuffling the message to which I reply for better presentation)

It seems a lot easier to write a match than to package it as a patch!
Perhaps my confusion is related to the fact that I went about this
whole process in some unexpected way.  I downloaded iptables-1.2.7a
and patch-o-matic-20020825 in order to look at existing code so I
could write my match.  Then I added stuff that looked similar to what
was there and built it.  I begin to think I should have instead
started with cvs checkout.  I see that contains netfilter/userspace
whereas I have no such directory.

 > Maybe it's a good idea to have a look at some other patches (like the
 > recently submitted hoplimit (hl) patches as an example.  I didn't need
 > to describe this into detail so far, everybody just figured..

I did try to look at other patches.  I think the example you site will
give an idea of the resulting problems:
http://lists.netfilter.org/pipermail/netfilter-devel/2003-January/010135.html
[RESEND][PATCH] Hop Limit match/target for IPv6 
contains about 20 diffs !  (I thought I needed about 3.)
What's the difference between the HL's and the hl's, I wonder.
And the first dozen or so don't contain any userspace.
And then there's a large base64 attachment at the end.

Whereas NEWPATCHES seems to be meant to tell me what to do.

 > > I've tried to follow directions in NEWPATCHES.
 > > I don't quite understand, though, where libipt_u32.c belongs.
 > 
 > no, it just belongs into the extensions subdirectory, together with a
 > .u32-test shellscript (similar to the others...)
This suggests that it should be part of what I send you.
But below you seem to say 3 files, which is what NEWPATCHES seemed
to indicate, and which is what I did send.

 > > It looks like you want me to download the current patch-o-matic cvs,
 > > make a copy of it with my 3 patch files, then do a diff.
 > > But this just contains my 3 patch files, right?
 > yup, it is a diff which adds 3 files (of which one is again a diff)
This is at least consistent with what I sent.

 > > So wouldn't that be the same as putting those files in one directory,
 > > creating a second directory with empty files of those names and doing
 > > the diff of those?
 > 
 > yes, it would turn out the same thing, as long as (like in the usual
 > case) there are no modifications to existing Makefiles, etc.
 > 
 > > Anyhow, see if this is what you wanted:
 > 
 > couple of comments:
 > 
 > 1) please include the patch 'netfilter/userspace' or at least
 > 'userspace', so the patch can be applied from the 'root' netfilter
 > directory. (this is not really important, but usual) (this is not really
 > important, but usual)

Am I correct that the complaint here is that instead of
 diff -ur u32-empty/u32.patch u32-added/u32.patch
you wanted something like
 diff -ur u32-empty/userspace/u32.patch u32-added/userspace/u32.patch
or
 diff -ur u32-empty/netfilter/userspace/u32.patch u32-added/netfilter/userspace/u32.patch
or
 diff -ur netfilter/userspace/u32.patch netfilter/userspace/u32.patch
?

 > 2) please don't include the u32 in extensions/Makefile...
The only Makefile in what I sent was
 diff -ur u32-empty/u32.patch.makefile u32-added/u32.patch.makefile
which was mentioned in NEWPATCHES:
 4) If you want to edit the Makefile...
Maybe you're saying I shouldn't do that.  
In which case
- how should I make u32 ?
- I end up with only 2 files in my patch, so one's missing from the
three that you agree above should be there.  Is that libipt_u32.c ?

 > .. but it seems like there is a need for documentation.  If you feel
 > NEWPATCHES should be extended in some way -> patches are welcome ;)
Sorry to be so dense.  Maybe when I finally see what I should have
done I'll have a better idea of what NEWPATCHES could have said to
lead me to that result.

In the mean while, here's what I regard as a summary of what I sent you.
Please tell me what you want to see in the corresponding summary of
what I send on the next try.
====
 $ grep diff /tmp/u32-diff
 diff -ur u32-empty/u32.patch u32-added/u32.patch
 +diff -ur /usr/src/linux-2.4.18-clean/include/linux/netfilter_ipv4/ipt_u32.h /usr/src/linux-2.4.18/include/linux/netfilter_ipv4/ipt_u32.h
 +diff -ur /usr/src/linux-2.4.18-clean/net/ipv4/netfilter/ipt_u32.c /usr/src/linux-2.4.18/net/ipv4/netfilter/ipt_u32.c
 diff -ur u32-empty/u32.patch.help u32-added/u32.patch.help
 diff -ur u32-empty/u32.patch.makefile u32-added/u32.patch.makefile
====
