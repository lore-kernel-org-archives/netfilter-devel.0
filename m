From: Peter Grace <pgrace@rttx.com>
Subject: Re: POSSIBLE BUG:  netfilter/ip_conntrack_core
Date: Tue, 24 Feb 2004 14:49:30 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403BAACA.9030009@rttx.com>
References: <4030DADD.1040104@rttx.com> <20040217140440.GH981@sunbeam.de.gnumonks.org> <403226F8.4040109@rttx.com> <20040217145534.GN981@sunbeam.de.gnumonks.org> <40323238.9050801@rttx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40323238.9050801@rttx.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hey guys,
~    This problem happened again today, and this time I actually got a
kernel panic screen.  Unfortunately, the stack trace was incomplete
(scrolled off the screen) so I couldn't give you guys a complete trace.
It definitely seemed to be the same problem (I was doing the same thing
that I did before -- adding a new static nat entry)

I'll find my original e-mail to linux-kernel and reforward it here --
below was my last communication to this list that enumerated all of the
stuff from REPORTING-BUGS.

Thanks a bunch,
Pete

Peter Grace wrote:

|
|
| Harald Welte wrote:
|
| | | You aren't running an SMP kernel (even if it's only a UP box),
| are | you?
|
| Nope, it's a uniprocessor kernel.
|
| Here is miscellaneous data gathered via REPORTING-BUGS instructions:
|
| [1.] One line summary of the problem:      Kernel freezes with
| netfilter tuplehash problem [2.] Full description of the
| problem/report:    See previous e-mail [3.] Keywords (i.e., modules,
| networking, kernel):  netfilter, NAT, conntrack [4.] Kernel version
| (from /proc/version):  2.6.1 ... [7.] Environment:  Debian GNU/Linux
| [7.1.] Software (add the output of the ver_linux script here)
|
| Linux brdgw1 2.6.1 #1 Fri Jan 23 17:26:33 EST 2004 i586 GNU/Linux
|
| Gnu C                  3.3.3 Gnu make               3.80 util-linux
| 2.12 mount                  2.12 module-init-tools      3.0-pre5
| e2fsprogs              1.35-WIP PPP                    2.4.2 Linux C
| Library        2.3.2 Dynamic linker (ldd)   2.3.2 Procps
| 3.1.15 Net-tools              1.60 Console-tools          0.2.3
| Sh-utils               5.0.91 Modules Loaded         af_packet unix
|
|
|
| [7.2.] Processor information (from /proc/cpuinfo):
|
| processor       : 0 vendor_id       : GenuineIntel cpu family      :
| 5 model           : 2 model name      : Pentium 75 - 200 stepping
| : 12 cpu MHz         : 199.751 fdiv_bug        : no hlt_bug         :
| no f00f_bug        : yes coma_bug        : no fpu             : yes
| fpu_exception   : yes cpuid level     : 1 wp              : yes flags
| : fpu vme de pse tsc msr mce cx8 bogomips        : 393.21
|
|
| [7.3.] Module information (from /proc/modules):
|
| af_packet 21576 2 - Live 0xc4837000 unix 27632 14 - Live 0xc481e000
|
| ...
|
| I cut some of the options out that I thought were not pertinent
| (i.e., IO ports and such -- if anyone wants this info, I'll be happy
| to supply)
|
| Thanks, Pete
|
|
| -- --- /------------------------------------------------\ |Peter
| Grace                  Phone: 484-875-9462 |Technology Analyst
| Fax: 484-875-9461 |RealTime Technologies, Inc.   Cell: 484-919-1400
| |835 Springdale Drive, Suite 101 |Exton, PA  19341
| \------------------------------------------------/


- --
- ---
/------------------------------------------------\
|Peter Grace                  Phone: 484-875-9462
|Technology Analyst             Fax: 484-875-9461
|RealTime Technologies, Inc.   Cell: 484-919-1400
|835 Springdale Drive, Suite 101
|Exton, PA  19341
\------------------------------------------------/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
 
iD8DBQFAO6rJ1bytwQSw7hoRAivdAKCTu/2D6MbcoVCsT4m0FwP7LzNXwACfWiqE
zLUEU+vL6W/tnvp8PAkS11w=
=M1g/
-----END PGP SIGNATURE-----
