From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: expect.timeout ... when?
Date: Mon, 18 Aug 2003 21:30:32 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308181130.h7IBUYo04085@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
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

Howdy,

  If a conntracker does not set the expect.timeout value, when
does an expectation expire?  To put it another way, when does
the expect memory get freed?

  Last Friday,  I left an experimental module running in my dev
box's kernel for the weekend ... the module was dodgy .. didn't do
proper checking on the expect master connection.  The dev box
didnt have any netfilter rules and only stock-kernel in-built netfilter
modules (for 2.4.21) other than my dodgy-mod.

  By the following monday morning morning, my dodgy-mod had
accepted so many new masters and set up so many new
expectations that I, as a single user running vi over an ssh
session, saw each key-stroke swapped out to disk -- all the
system memory was waaaaaay gone.

  Doing an 'rmmod' on my dodgy-mod freed all of the missing
memory.  The module's big fault was that it set up an expect for
just about anything that hit it ... but of course, none of the
expectations were ever confirmed.  The module had no .timeout
set, and no .max_expected set.

  Soooo, looking at modules such as the ftp conntracker where
the timeout is not set ... but max_expected is set ( == 1) .. then
is there a DoS condition that can be setup by causing  a single
unmatched ftp session?

  Just doing a quick sanity check on my thinking here ... [single
user server systems running out of memory in 60 hours, keeps
me awake at night; makes one appreciate the value of poorly
spec'd boxen tho].

Ta,



BTW, how's the netfilter.org web hit count going since you guys
started going with the "raunchy programmer" campaign? ;-)   

     http://gnumonks.org/static/photos/laforge-lsm-kilt.jpg


Cute skirt LaForge ;-))




--
Ian Latter
Internet and Networking Security Officer
Macquarie University
