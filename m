From: Peter Surda <shurdeek@routehat.org>
Subject: Re: REDIRECT changes DST address of the packet
Date: Thu, 30 Jun 2005 12:11:24 +0200
Message-ID: <2005530121124577@mail.routehat.org>
References: <Pine.LNX.4.62.0506301007180.22412@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.62.0506301007180.22412@bizon.gios.gov.pl>
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

On Thu, 30 Jun 2005 10:08:55 +0200 (CEST) Krzysztof Oledzki <olenf@ans.pl=
>
wrote:

>> If I lose original DST address, how can I persist
>> that value in that packet.
>Please use getsockopt() with SO_ORIGINAL_DST.
Hehe you were faster than me :-).

Nari, if you don't understand how to do this, check out the source of som=
e
transparent proxies (squid, p3scan) for examples (as Krzysztof said, grep=
 for
SO_ORIGINAL_DST). I think it's straightforward, I even managed to reprodu=
ce this
in perl without using any C.

>Best regards,
> 				Krzysztof Ol=C4=99dzki
Yours sincerely,
Peter
