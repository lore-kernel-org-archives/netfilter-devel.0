From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [Fwd: Re: "ip_conntrack_core: Frag of proto 17." error and memory
 leak?]
Date: Tue, 23 Sep 2003 12:24:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0309231204140.24180-100000@blackhole.kfki.hu>
References: <1064090237.28506.83.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1064090237.28506.83.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 20 Sep 2003, Martin Josefsson wrote:

> Ok it was as I suspected.
> ipt_NOTRACK calls ip_conntrack_get_tuple() which calls get_tuple() for
> all packets, even fragments and get_tuple() barfs and returns 0 so
> NOTRACK doesn't mark the packet as untracked.

Oh, my stupidity! I'll add the banner to the code:

/* Even when the intention was to write a code with the given
 * functionality, any reseblance in the actual behavior to the
 * intended one is due to pure luck.
 */

[...]
> A small variant of this is to still split ip_find() into two functions
> and if we find that the fragment is expected (either conntrack or the
> ipstack has seen the first packet and tries to defrag it) we simply
> continue the defraging on their behalf and rerun the now complete packet
> through ip_conntrack_tuple_taken() to see if conntrack should have it or
> not. This way I think everyone's happy. There will be some extra
> searching in the defrag-hashtable for all fragments handled by NOTRACK
> and one extra search in conntrack for each defragged packet. For the
> case where the arriving fragments are expected there will be two
> searches in the defrag-hashtable unless we split those things up a bit
> and modify them, I wonder how keen davem is on that.

What about calling ip_ct_gather_frags directly in the NOTRACK target?
It'd be straightforward and in the target we already depend on conntrack.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
