From: Ryan Veety <ryan@ryanspc.com>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Wed, 29 Oct 2003 13:20:30 -0500 (EST)
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310291303270.22903@ryanspc.com>
References: <3F9B8A5D.9010803@triaton-webhosting.com> <200310261052.25944.rezso@rdsor.ro>
 <20031026223438.1cf757ce.davem@redhat.com> <3F9ED206.4040806@triaton-webhosting.com>
 <20031028231317.7840e47f.davem@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Georg Chini <georg.chini@triaton-webhosting.com>, rezso@rdsor.ro,
	sparclinux@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <sparclinux-owner@vger.kernel.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031028231317.7840e47f.davem@redhat.com>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Oct 2003, David S. Miller wrote:

>
> Ok, here is the patch I'm using to fix this, please test.
>
> Thanks again for figuring out the problem Georg.

Works here, -F flushes properly.  The only remaining netfilter issue I noticed
is limiting doesn't work on sparc64.  The following works fine on an x86
machine running 2.6.0-test9.

# iptables -A INPUT -i eth0 -p icmp -m limit --limit 10/second -j ACCEPT
iptables: Invalid argument

No biggie for me, just happened to notice it.

Ryan
     __________________________________________________________
   .'  Ryan Veety <ryan@ryanspc.com> - http://www.ryanspc.com  `.
   |          PGP Key: http://www.ryanspc.com/pgp.txt           |
    `----------------------------------------------------------'
