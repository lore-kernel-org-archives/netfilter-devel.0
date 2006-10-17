From: Eric Leblond <eric@inl.fr>
Subject: Re: queue_maxlen
Date: Wed, 18 Oct 2006 00:54:45 +0200
Message-ID: <1161125685.4002.33.camel@localhost.localdomain>
References: <2BDDB86A-ABD4-4C53-AE17-498AB0F52B28@cadvium.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: robert <rbscott@cadvium.net>
In-Reply-To: <2BDDB86A-ABD4-4C53-AE17-498AB0F52B28@cadvium.net>
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

Hi,

Le mardi 17 octobre 2006 =E0 15:43 -0700, robert a =E9crit :
> Does NFQUEUE use the value in /proc/sys/net/ip_queue_maxlen?  If not, =20
> is it possible to modify the maximum queue length for NFQUEUE?

Not with vanilla tree.

I've post a patch to enable it some times ago but It has not been
incorporated into main tree :

http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3628
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3629

With that patch it is possible to do so on a per-queue basis by using
the new function nfq_set_queue_maxlen.

BR,
--
Eric Leblond
