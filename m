From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: HL target in the kernel
Date: Fri, 11 Apr 2003 10:40:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304111030280.31394-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.51.0304051703030.2841@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0304051703030.2841@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Maciej,

On Sat, 5 Apr 2003, Maciej Soltysiak wrote:

> i have seen that the hl match has been submitted to the kernel,
> but why was not the HL target submitted? Does it lack something?

The HL target is similar to the TTL target - and the latter isn't
submitted to the kernel either.

It seems to me there is dead code in the HL target. Could you fix it and
resubmit the corrected patch?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
