From: William Stearns <wstearns@pobox.com>
Subject: PSD and recent are _very_ picky about option order: "missing optarg"
Date: Mon, 8 Dec 2003 22:04:13 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312082118580.1981-100000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ML-recent <ipt_recent@snowman.net>, Stephen Frost <sfrost@snowman.net>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Markus Hennig <hennig@astaro.de>, Dennis Koslowski <koslowski@astaro.de>,
   Jan Rekorajski <baggins@pld.org.pl>
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
	I'm trying to use psd to detect port scans.  Once I find a 
scanning IP address, I'd like to save that IP in a recent table called 
"mappers".
	Here's a simple run, lines wrapped for readability.  The first 
fails when psd is loaded first; in the second command I load "recent" 
first:


# iptables -N testchain

# iptables -A testchain -m psd -m recent --name mapper --set
iptables v1.2.9-20031126: missing optarg
Try `iptables -h' or 'iptables --help' for more information.

# iptables -A testchain -m recent --name mapper --set -m psd

	The first form fails, but I can't understand why; what option 
would psd require?  Shouldn't it stop parsing at the next "-m"?
	If I add all the parameters it should want, I don't get any 
further:

# iptables -A testchain -m psd --psd-weight-threshold 21
--psd-delay-threshold 300 --psd-lo-ports-weight 3 --psd-hi-ports-weight 1
-m recent --name mapper --set

iptables v1.2.9-20031126: missing optarg
Try `iptables -h' or 'iptables --help' for more information.

	If I leave off the recent module, it loads fine:

# iptables -A testchain -m psd --psd-weight-threshold 21
--psd-delay-threshold 300 --psd-lo-ports-weight 3 --psd-hi-ports-weight 1


	The only way I can seem to get them to load together is this:

# iptables -A testchain -m recent --name mapper -m psd --set

	Recent first, psd next, and recent's "--set" at the end (it works 
with or without the --psd* parameters between "-m psd" and "--set").

	The order makes a difference to me.  If I do the original way 
("iptables -A testchain -m recent --name mapper --set -m psd"), the rule 
adds the source IP to the mapper table before I've even tested to see if 
this is part of a port scan.

	Why does the --set need to be after the -m psd?  Am I doing 
something _really_ stupid?

	iptables and patch-o-matic are both 20031126, kernel is 
2.6.0-test11.
	Cheers,
	- Bill

---------------------------------------------------------------------------
        "I've discovered that using VMS is a lot like driving a nail
with your head: sure, you eventually get something practical done, but
it usually results in a headache and some blood loss."
(Courtesy of Dmitri <dmitri@users.sourceforge.net> and Sean A. Simpson)
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------
