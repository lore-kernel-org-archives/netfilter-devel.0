From: Andreas Schwab <schwab@suse.de>
Subject: Re: compat_xt_counters is not compatible
Date: Sat, 15 Apr 2006 16:16:33 +0200
Message-ID: <jeejzykjpa.fsf@sykes.suse.de>
References: <jeacaoqdxn.fsf@sykes.suse.de> <200604151811.54013.dim@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@sw.ru>
In-Reply-To: <200604151811.54013.dim@sw.ru> (Dmitry Mishin's message of "Sat,
	15 Apr 2006 18:11:53 +0400")
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

Dmitry Mishin <dim@sw.ru> writes:

> compat_xt_counters should be used only for 32bit processes, which has 4=
 byte=20
> alignment.

This is wrong.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED=
5
"And now for something completely different."
