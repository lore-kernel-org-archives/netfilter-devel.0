From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Mon, 14 Jun 2004 10:57:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406141055220.12847-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0406141036530.759@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0406141036530.759@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 14 Jun 2004, Martin Josefsson wrote:

> > Why did the prefix get truncated to 'ip_conntrack_tcp: INVALID: bad T'???
> > Anything special with your kernel?
>
> No nothing special, using ULOG for logging.
> I thought it was weird as well but I didn't trace the problem. Maybe I'll
> look at it later today.

I found it: the ulog prefix length is 32. I'll try to cut back the strings
to fit into that buffer.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
