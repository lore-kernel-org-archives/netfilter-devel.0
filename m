From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Tue, 02 Aug 2005 13:14:54 +0200
Message-ID: <m21x5czj2p.fsf__8405.53990933604$1122994947$gmane$org@cerbere.dyndns.info>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050731080143.GA10374@rama.de.gnumonks.org> (Harald Welte's
	message of "Sun, 31 Jul 2005 10:01:43 +0200")
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

Harald Welte <laforge@netfilter.org> writes:

> I suggest pulling the git tree from 
>
> rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git
>
> It is based on David Miller's net-2.6.14.git, and only contains those
> new features and fixes that I intend to push to him soon (or have
> already submitted but have not yet been included).
>

I started a tree for extensions in the p-o-m.
The git tree has already around 30 extensions, and is based on davem's
net-2.6.git

you can dowload the tarball of this tree here:
http://people.mandriva.com/~sbellabes/nf-2.6.git.tar.gz
http://people.mandriva.com/~sbellabes/git/nf-2.6.git/

Yes, i know, a rsync should be better, but the only server i got which
can host a rsync server, has a DSL link :/ 
Harald, can you provide hosting ? 

TODO:
  - updating patch for being sync with svn, but for now, we got a
structured tree.
  - add more extensions (sip, ..)

Here is the changelog against davem's tree for each branches
(main updates are kill lockhelp.h and fix compile problems, the branches
mdv is the merge branches of all extensions)

new targets:
  - ROUTE 
    o [NETFILTER] IPv{4,6} ROUTE target from svn-netfilter rev 3983
    o [NETFILTER] kill nf_debug for ROUTE
    o [NETFILTER] fix prototype function match for ROUTE
    o [NETFILTER] Need to export symbol nd_tbl for ROUTE IPv6

  - HOPLIMIT
    o [NETFILTER] IPv6 HOPLIMIT target from svn-netfilter rev 3983
    o [NETFILTER] fix prototype function match for HOPLIMIT

  - TARPIT
    o [NETFILTER] IPv4 TARPIT target from svn-netfilter rev 3983
    o [NETFILTER] kill nf_debug for TARPIT

  - IPV4OPTSSTRIP
    o [NETFILTER] IPv4 IPV4OPTSSTRIP target match from svn-netfilter rev 3983

  - IPMARK
    o [NETFILTER] IPv4 IPMARK target from svn-netfilter rev 3983

  - XOR
    o [NETFILTER] IPv4 XOR target from svn-netfilter rev 3983
    o [NETFILTER] XOR Makefile + Kconfig (svn rev 3983)

  - TTL
    o [NETFILTER] IPv4 TTL target from svn-netfilter rev 3983

matchs:
  - connrate :
    o [NETFILTER] IPv4 connrate match from svn-netfilter rev 3983
    o [NETFILTER] Kill lockhelp.h for connrate
    o [NETFILTER] Missing include for SMP (connrate)

  - nf_conntrack
    o [NETFILTER] IPv{4,6} nf_conntrack from svn-netfilter rev 3983
    o [NETFILTER] kill lockhelp.h for nf_conntrack
    o [NETFILTER] kill nf_debug for nf_conntrack
    o [NETFILTER] Fix compiling error with inline function nf_ct_put
    o [NETFILTER] dst_pmtu is no longer used for kernel >= 2.6.12
    o [NETFILTER] fix typo and missing lock for nf_conntrack

  - nth
    o [NETFILTER] IPv{4,6} nth match from svn-netfilter rev 3983
    o [NETFILTER] fix prototype function match for nth ipv6

  - random
    o [NETFILTER] IPv{4,6} random match from svn-netfilter rev 3983
    o [NETFILTER] Fix struct ipt_match ipt_rand_reg
    o [NETFILTER] fix prototype function match for random ipv4
    o [NETFILTER] fix prototype function match for random ipv6

  - pptp-conntrack-nat
    o [NETFILTER] IPv4 pptp-conntrack-nat from svn-netfilter rev 4096
    o [NETFILTER] Kill lockhelp.h for pptp-conntrack-nat
    o [NETFILTER] Fix missing ip_nat_pptp.h
    o [NETFILTER] kill lockhelp.h for pptp-conntrack-nat part 2
    o [NETFILTER] kill lockhelp.h for proto_gre
    o [NETFILTER] Define macros for pptp-conntrack-nat
 
  - fuzzy
    o [NETFILTER] IPv{4,6} fuzzy match from svn-netfilter rev 3983
    o [NETFILTER] fix prototype function match for fuzzy

  - condition
    o [NETFILTER] IPv{4,6} condition match from svn-netfilter rev 3983
    o [NETFILTER] Fix prototype function 'match'
    o [NETFILTER] fix compiling warnings in ip6t_condition

  - ipset
    o [NETFILTER] IPv4 ipset match/TARGET from svn-netfilter rev 3983
    o [NETFILTER] kill lockhelp.h for ipset

  - rsh-conntrack
    o [NETFILTER] IPv4 rsh-conntrack from svn-netfilter rev 4096
    o [NETFILTER] Kill lockhelp.h for rsh-conntrack
    o [NETFILTER] kill lockhelp.h for rsh part 2

  - rtsp_conntrack
    o [NETFILTER] IPv4 rtsp_conntrack from svn-netfilter rev 3983
    o [NETFILTER] Kill lockhelp.h for rtsp_conntrack
    o [NETFILTER] Introduce ip_ct_rtsp_master

  - ipv4options
    o [NETFILTER] IPv4 ipv4options match from svn-netfilter rev 3983

  - string (not enabled in configs)
    o [NETFILTER] IPv4 string match from svn-netfilter rev 3983

  - quota : [NETFILTER] IPv4 quota match from svn-netfilter rev 3983
  - mport : [NETFILTER] IPv4 mport match from svn-netfilter rev 3983
  - connlimit : [NETFILTER] IPv4 connlimit match from svn-netfilter rev 3983
  - time : [NETFILTER] IPv4 time match from svn-netfilter rev 3983
  - psd : [NETFILTER] IPv4 psd match from svn-netfilter rev 3983
  - osf : [NETFILTER] IPv4 osf match from svn-netfilter rev 3983
  - ipp2p : [NETFILTER] IPv4 ipp2p match from svn-netfilter rev 3983

others:
  - ip_queue_vwmark : [NETFILTER] ip_queue_vwmark from svn-netfilter rev 3983


-- 
Samir Bellabes
Mandriva
