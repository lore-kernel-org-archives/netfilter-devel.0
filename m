From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: 08 Jun 2002 17:03:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023548616.19835.59.camel@tux>
References: <1023365846.845.26.camel@tux>
	<20020608073733.GB1109@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020608073733.GB1109@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-06-08 at 09:37, Harald Welte wrote:
 
> ah. now I understand what the exporting was all about :)

:)
 
> sounds interesting and should give quite some speedup.  Did you do any
> benchmarking on that?

I need to get a slower test-router so I can benchmark properly :(

I need to get a very old pentium or high-end 486 with PCI.

I implemented this a while ago and then accidentally lost the sourcetree
but I did do some profiling which I can't find now :(

A similar thing was recently done in VFS in kernel 2.5 for the atime
updates and it gave a very nice speedup, I doubt the speedup will be as
large here since the timer handling is a lot faster than disk-io.

I'm currently in the process of going through the locking in conntrack
to try and make it more scalable (splitting ip_conntrack_lock) and
trying to fix things I find.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
