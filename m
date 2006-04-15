From: Andreas Schwab <schwab@suse.de>
Subject: Re: compat_xt_counters is not compatible
Date: Sat, 15 Apr 2006 19:31:54 +0200
Message-ID: <jeacamkanp.fsf@sykes.suse.de>
References: <jeacaoqdxn.fsf@sykes.suse.de> <44412142.9070409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44412142.9070409@trash.net> (Patrick McHardy's message of "Sat,
	15 Apr 2006 18:37:22 +0200")
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

Patrick McHardy <kaber@trash.net> writes:

> Andreas Schwab wrote:
>> struct compat_xt_counters uses uint32_t[4], which has 4 byte alignment=
,
>> but userspace uses uint64_t[2], which has 8 byte alignment.  This brea=
ks
>> iptables in 2.6.17-rc1.
>
> Did you actually see the breakage?

Of course.

> gcc on x86

Not all the worlds an x86.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED=
5
"And now for something completely different."
