From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re[2]: REJECT target
Date: Thu, 26 Jun 2003 08:40:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu>
References: <1051987037.20030625161343@habitat-b.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
In-Reply-To: <1051987037.20030625161343@habitat-b.de>
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

On Wed, 25 Jun 2003, DarKRaveR wrote:

> I understood that, the question is why ? I got a scenarion, where I
> would need it in the PREROUTING chain of the nat table, instead of
> just dropping the packets ... Is there any reason, why it is only
> available in the filter table. I mean, it's for filtering okay, but
> maybe I want to reject connections properly at other places (like nat
> table, prerouting) instead of plain stupid
> dropping them and waiting at the client software to time out.

Thy users of netfilter do not filter packets in the nat or mangle tables.

[Check out the mailing list archive and the documentation if you do not
know why. We discussed it countless times.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
