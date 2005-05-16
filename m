From: Silimite <silimite@gmail.com>
Subject: ip_queue/libipq panics on SMP kernel
Date: Mon, 16 May 2005 12:31:33 -0400
Message-ID: <5ad977d105051609312d0aae18@mail.gmail.com>
Reply-To: Silimite <silimite@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Is anyone successfully using the QUEUE (with libipq) stuff on SMP kernels?

I'm just curious because I've never been able to get it to run for
more than a few hours before the kernel freezes/panics.   I've tried
many different kernel versions from the 2.6 series and I have tried on
several different machines running different Linux distros.  I have
had other people report the same problem.

Even a simple program that does nothing but set the verdict to
NF_ACCEPT will eventually kill the whole system.  It appears that you
need a rule loaded into iptables and a program listening and
processing the queued packets.  The time it takes varies anywhere from
a few minutes to several hours before the machine dies (race
condition?).

This has something to do with SMP because if I compile a non-SMP
kernel everything works fine, then if I use the exact same kernel
config except compiled with SMP turned on then ip_queue causes
problems.  This is irregardless of whether or not I'm actually using
multiple processors or even an SMP capable machine.

I also noticed that the libipq header(s) are not C++ friendly.  The
header does not do a "#ifdef __cplusplus" extern "C" check.

s
