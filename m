From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: possible bug in ip_nat_fn()
Date: Wed, 13 Aug 2003 14:37:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0308131432300.5634-100000@blackhole.kfki.hu>
References: <20030810141425.GA4906@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20030810141425.GA4906@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Bazsi,

On Sun, 10 Aug 2003, Balazs Scheidler wrote:

> The problem occurs if no ip_nat_setup_info() is called (or it fails) _AND_
> ret == NF_ACCEPT. This is always the case in 2), when 'ret' is simply set to
> NF_ACCEPT, and might possibly also happen if the NAT helper does not check
> the return value of ip_nat_setup_info(), or it simply does not set up a NAT
> mapping for the current connection.
[...]
> I think the solution for this problem would be a separate flag in
> ip_nat_info->initialized which tells whether this conntrack has already been
> hashed, or to move the hash update code to ip_nat_setup_info. I've attached
> a patch which does the latter, and makes the place_in_hashes and
> replace_in_hashes functions static.

I think your analysis is correct and I agree with your fix as well.

Could you report this and all your other findings in the workshop during
presenting the TPROXY patch?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
