From: Patrick McHardy <kaber@trash.net>
Subject: Re: ERROR target in /proc/net/ip_tables_targets
Date: Thu, 27 Nov 2003 06:20:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0311270612230.30430@gw.localnet>
References: <20031127042854.GE1084@eychenne.org> <Pine.LNX.4.58.0311270536590.30430@gw.localnet>
 <20031127050742.GB2740@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20031127050742.GB2740@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Herve Eychenne wrote:

> Yes, except than when you do a cat /proc/net/ip_tables_targets and
> read "ERROR" at the end of the list, you get the strong (and
> unpleasant) feeling that something went wrong and that the list may
> not be complete (even if _you_ (netfilter developer) know it is).

I never thought of it this way .. I actually had to laugh out about my
ignorance not realizing what ERROR means to most people ;)

> So (even if I understand your concerns at the time you wrote the
> patch) this is IMHO not acceptable.
> Please, let's not sacrifice "ignorant" user time and confidence for a
> few duplicate lines of kernel code...
>
>  Herve

Yes I totally understand your point, I'm going to fix it when I get
around.

Best regards,
Patrick

>
> --
>  _
> (=B0=3D  Herv=E9 Eychenne
> //)
> v_/_ WallFire project:  http://www.wallfire.org/
>
