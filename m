From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp window tracking question
Date: Wed, 15 Dec 2004 08:51:03 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412150849450.22202@blackhole.kfki.hu>
References: <00f901c4e21c$452634f0$0e25fe0a@pysiak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <00f901c4e21c$452634f0$0e25fe0a@pysiak>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Maciej,

On Tue, 14 Dec 2004, Maciej Soltysiak wrote:

> Is the tcp window tracking code in effect only when ip_conntrack is loaded
> or regardles of ip_conntrack?

Of course the former. It's an enhanced way of TCP connection tracking.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
