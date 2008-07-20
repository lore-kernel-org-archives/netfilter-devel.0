From: "G.W. Haywood" <ged@jubileegroup.co.uk>
Subject: Re: [ANNOUNCE] ipset-2.3.3
Date: Sun, 20 Jul 2008 15:31:28 +0100 (BST)
Message-ID: <Pine.LNX.4.58.0807201524360.8513@mail3.jubileegroup.co.uk>
References: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi there,

On Sat, 19 Jul 2008, Jozsef Kadlecsik wrote:

> This is a compatibility fix release of ipset which supports kernel
> versions >= 2.6.16 and 2.4.36.x [snip]
> If you run ipset on a 2.4 kernel, please upgrade as you'll get all the
> bugfixes (which had been forgotten to backport) and iptreemap support.

Currently running 2.4.35.1 patched for ipsets by hand using the old
POM sources.  No problems with that at all.

Using fresh kernel 2.36.6 source and the ipsets source download from
http://ipset.netfilter.org/ I can't seem to get past this failure to
build the kernel, no matter how I permute the building and patching
instructions, although I've put no time into actually debugging it:

ip_set.c: In function `ip_set_register_set_type':
ip_set.c:329: parse error before ',' token
ip_set.c: In function `ip_set_create':
ip_set.c:840: parse error before ',' token
make[3]: *** [ip_set.o] Error 1
make[3]: Leaving directory `/mnt/hde3/gwh/src/linux/linux-2.4.36.6/net/ipv4/netfilter'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory `/mnt/hde3/gwh/src/linux/linux-2.4.36.6/net/ipv4/netfilter'
make[1]: *** [_subdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/mnt/hde3/gwh/src/linux/linux-2.4.36.6/net'
make: *** [_dir_net] Error 2

Just a heads up, as far as I'm concerned this isn't an urgent issue. :)

--

73,
Ged.
