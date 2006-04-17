From: Andreas Schwab <schwab@suse.de>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 16:05:23 +0200
Message-ID: <jeu08se1r0.fsf@sykes.suse.de>
References: <444132C1.1020604@trash.net> <200604171459.13312.dim@openvz.org>
	<je64l8fmhw.fsf@sykes.suse.de> <200604171604.18471.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: dev@openvz.org, netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200604171604.18471.dim@openvz.org> (Dmitry Mishin's message of
	"Mon, 17 Apr 2006 16:04:17 +0400")
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

Dmitry Mishin <dim@openvz.org> writes:

> On Monday 17 April 2006 15:51, Andreas Schwab wrote:
>> Dmitry Mishin <dim@openvz.org> writes:
>> > diff --git a/include/asm-ia64/compat.h b/include/asm-ia64/compat.h
>> > index 40d01d8..3e6417b 100644
>> > --- a/include/asm-ia64/compat.h
>> > +++ b/include/asm-ia64/compat.h
>> > @@ -34,6 +34,8 @@ typedef s32		compat_long_t;
>> >  typedef u32		compat_uint_t;
>> >  typedef u32		compat_ulong_t;
>> >
>> > +typedef u64 __attribute__((aligned(4)))	compat_uint64_t;
>>
>> The aligned attribute cannot decrease alignment.
> With my gcc (3.3.5) it can.

You're right, this is a special case (in general it can't without the
packed attribute).

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED=
5
"And now for something completely different."
