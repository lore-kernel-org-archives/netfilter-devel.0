From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Tue, 14 Feb 2006 21:41:59 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602142138090.23784@blackhole.kfki.hu>
References: <43F0B76E.7050007@trash.net>
	<200602140348.k1E3msEc020481@toshiba.co.jp>
	<43F204B8.5060700@trash.net>
	<200602141759.k1EHxfk0009760@toshiba.co.jp>
	<43F21DBC.70506@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	laforge@gnumonks.org, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F21DBC.70506@trash.net>
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

On Tue, 14 Feb 2006, Patrick McHardy wrote:

> Yasuyuki KOZAKAI wrote:
> > IIRC, __{ip,nf}_conntrack_confirm is called at POSTROUTING and INPUT,
> > after all processing of packet filter. If I do
> >
> > 	ip6tables -A FORWARD -p tcp --dport 22 -j REJECT
> >
> > on my router, the conntrack of TCP SYN packet of ssh will never confirmed
> > and then nf_conntrack will create new conntrack for TCP RST at OUTPUT.
>
> RSTs and ICMP errors without existing connections should be ignored
> by conntrack (and marked as INVALID). Are you sure the RSTs create
> new conntracks?

Marking packets created by the REJECT target as INVALID would break
the functionality of the target itself. Even if there is no real
"master" connection, RELATED was more appropriate.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
