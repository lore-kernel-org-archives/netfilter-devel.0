From: William Stearns <wstearns@pobox.com>
Subject: Converting patch-o-matic over to 2.6 kernel format - most of the
 work done.
Date: Sun, 16 Nov 2003 17:01:55 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311161654000.22726-100000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, all,
	Because the 2.6 kernel has moved from a .config.in and 
.configure.help to a Kconfig format, the patch-o-matic collection won't 
cleanly apply.
	I've written a converter that pulls in the lines from pom's
.config.in and .configure.help files and creates a something.patch.Kconfig
file, ready to be used on a 2.6 kernel.  The converter tool is at
http://www.stearns.org/pom26convert .  I've included a sample output; the
HL.patch.ipv6.config.in and HL.patch.ipv6.configure.help files were 
converted over to the HL.patch.ipv6.Kconfig .  The converter warned the 
user at run-time that it wasn't able to handle the if/fi lines in 
.config.in; the person running it will probably have to do some cleanup 
work on perhaps 20% of the files.
	I have not patched "runme" to actually put these into 
net/ipv{4,6}/netfilter/Kconfig; would somebody else be willing to finish 
that portion?  Unless I've missed something crucial, this is pretty close 
to being ready to go.
	Cheers,
	- Bill

---------------------------------------------------------------------------
	"Any sufficiently advanced technology is indistinguishable from
magic." 
	-- Arthur C. Clark (?)
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------
