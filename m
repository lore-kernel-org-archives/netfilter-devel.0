From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Rule optimization scheme openbsd-like
Date: Tue, 14 Oct 2003 12:23:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310141221070.656-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.51.0310131004000.17633@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0310131004000.17633@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 13 Oct 2003, Maciej Soltysiak wrote:

> 2.8. Transparent rule set evaluation optimization
>
> pf automatically optimizes the evaluation of the rule set. If a group of
> consecutive rules all contain the same parameter, e.g., ``source address
> equals 10.1.2.3,'' and a packet does not match this parameter when the
> first rule of the group is evaluated, the whole group of rules is skipped,
> as the packet can not possibly match any of the rules in the group.
[...]
> What do you think? Is anyone working on this

nf-hipac is already available and it's more superior than the pf approach.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
