From: Peter Surda <surda@shurdix.com>
Subject: Re: Bug in ipset -R
Date: Mon, 22 Aug 2005 10:28:46 +0200
Message-ID: <200572210284618636@mail.routehat.org>
References: <Pine.LNX.4.58.0508220940360.20621@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0508220940360.20621@blackhole.kfki.hu>
Content-Disposition: inline
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

On Mon, 22 Aug 2005 09:49:22 +0200 (CEST) Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:

>because the restore commands must follow each other in a rigid order (th=
e
>feature): define the set, add all elements, *then* define next set and a=
dd
>its elements.
Aha so that's why I've been getting odd segfaults. I thought I patched it=
 wrong
or something.

>The corrected check to ensure the proper ordering will be added to the
>next release.
Thnx. In the meantime I'll rewrite my scripts to adapt for this. But it's=
 good
to know that for a change something is not my fault ;-).

BTW is this mentioned in the docs? If not, please do so.

>Best regards,
>Jozsef

--=20
http://www.shurdix.org - Linux distribution for routers and firewalls
