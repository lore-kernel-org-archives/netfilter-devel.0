From: "Gary Cote" <gcote@transat-tech.com>
Subject: Will netfilter patches be submitted to kernel base?
Date: Mon, 23 Jun 2003 14:48:44 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OKEKIACJCGNKMLKPKIIKEENFCOAA.gcote@transat-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Can anyone brief me on whether there's any sort of master
plan to submit the netfilter patches into the kernel base?
And further, whether there's any thought to back porting 
them to 2.4.x? If effort is the limiting factor, then my
company may be sufficiently motivated to cough up some
free time.

Or ... let me ask you this:

I'm specifically interested in the pptp-conntrack-nat patch.
I noticed that the patch modifies ip_conntrack_core.c and
ip_nat_core.c. Aside from what appear to be debug statements,
it looks like a net change of *two* lines of code. The rest of
the patch consists of new files.

Would it be possible to get only those small changes into the 
kernel base? Then, we'd be able to build the GRE/PPTP helpers 
as loadable modules and not have to patch the kernel.

We're something of a value-added reseller. We bundle our system
software within a linux workstation. We've so far managed to run 
our product on off-the-shelf distros and would prefer not to get
into the business of building, shipping, and maintaining custom
kernels.

Thoughts would be appreciated.
