From: Willy TARREAU <willy@w.ods.org>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Mon, 10 May 2004 00:27:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040509222724.GA11542@pcw.home.local>
References: <Pine.LNX.4.33.0405071658020.4133-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Harald Welte <laforge@netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0405071658020.4133-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef & Harald,

The REJECT patch in recent pom-ng does not compile. It references several
structure members which are not defined in 2.4 :
  fl.fl_icmp_type
  fl.fl_icmp_code
  fl.fl_ip_sport
  fl.fl_ip_dport

Since these are just macros, I grabbed them from 2.6 and tried to recompile,
but the compile failed on several other places referencing things that I
believe only exist in 2.6, so I gave up. BWT, the declaration of 'proto'
in send_reset is not gcc-2.95 proof :

   u8 proto;
   struct flowi fl;
   proto = oip6h->nexthdr;
   int err;

It would be nice if someone with a better knowledge would recheck this patch
before a release.

Cheers,
Willy
