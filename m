From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw/NOTRACK + TARPIT = good idea?
Date: Mon, 24 Nov 2003 09:11:17 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311240903430.12476-100000@blackhole.kfki.hu>
References: <3FBE89E9.1020307@vialink.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Juan Carlos Castro y Castro <jcastro@vialink.com.br>
In-Reply-To: <3FBE89E9.1020307@vialink.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Nov 2003, Juan Carlos Castro y Castro wrote:

> I'm thinking about the TARPIT target, and that it's a shame it will
> use resources if my box does conntrack. But if I previously pass them
> through -t raw -j NOTRACK, can I have the best of both worlds, i.e., a
> routing NAT box who is able to tarpit undesired packets itself?

Yes, but you have to take care both directions for the tarpitted
sessions. That's the price using the NOTRACK target.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
