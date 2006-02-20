From: Jes Sorensen <jes@sgi.com>
Subject: Re: [NET][IA64] Unaligned access in sk_run_filter
Date: 20 Feb 2006 10:43:16 -0500
Message-ID: <yq0u0auqbmz.fsf@jaguar.mkp.net>
References: <200602201828.29098.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, devel@openvz.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030289AbWBTPnU@vger.kernel.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200602201828.29098.dim@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>>>>> "Dmitry" == Dmitry Mishin <dim@openvz.org> writes:

Dmitry> Hello, We have an issue on ia64 box. It is easy triggerable
Dmitry> 'kernel unaligned access' in sk_run_filter:

Dmitry>         ptr = load_pointer(skb, k, 4, &tmp);
Dmitry>         if (ptr != NULL) {
Dmitry>                  A = ntohl(*(u32 *)ptr); << here

Change the above line to something like this:

                        A = ntohl(get_unaligned((u32*)ptr));

And add an #include <asm/unaligned.h>

Cheers,
Jes
