From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: work on ip%ip ipset
Date: Tue, 17 Oct 2006 10:09:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0610171000110.17511@blackhole.kfki.hu>
References: <b322db070610162309x379e504eud538c7e4f05ae045@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Retesh <retesh.chadha@gmail.com>
In-Reply-To: <b322db070610162309x379e504eud538c7e4f05ae045@mail.gmail.com>
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

On Tue, 17 Oct 2006, Retesh wrote:

> Currently, is there any work going on, for developing a IPSet like
> ipiphash containing a pair of IPs as ip1%ip2, similiar to ipporthash
> as ip%port.

ipset is in maintenace mode: bugfixes and minor (backward-compatible)
changes are accepted/added to the code only.

nfset is under development (alas, with a huge gap in the active work),
focusing on the follwing features:

- netlink kernel-user interface instead of [sg]etopt
- "binding" is dropped as a dead-end and new set types
  like the one you mentioned will be introduced: ip-ip pairs, etc.
- IPv6 address support

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
