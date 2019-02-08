From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Update pf.os with newer OS fingerprints
Date: Fri, 8 Feb 2019 17:07:25 +0100
Message-ID: <20190208160725.aen3uil2jmfnp6zc@salvia>
References: <7d39a0dc-d7bd-7934-1d86-7268bf7c51b9@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: tech@openbsd.org, netfilter-devel@vger.kernel.org
To: Fernando Fernandez Mancera <ffmancera@riseup.net>
Return-path: <owner-tech+M68999=goot+2Dtech=gmane.org@openbsd.org>
Content-Disposition: inline
In-Reply-To: <7d39a0dc-d7bd-7934-1d86-7268bf7c51b9@riseup.net>
List-Help: <mailto:majordomo@openbsd.org?body=help>
List-Owner: <mailto:owner-tech@openbsd.org>
List-Post: <mailto:tech@openbsd.org>
List-Subscribe: <mailto:majordomo@openbsd.org?body=sub%20tech>
List-Unsubscribe: <mailto:majordomo@openbsd.org?body=unsub%20tech>
Sender: owner-tech@openbsd.org
List-Id: netfilter-devel.vger.kernel.org

Hi Fernando,

On Fri, Feb 08, 2019 at 03:06:00PM +0100, Fernando Fernandez Mancera wrote:
> Hi,
> 
> I have been updating the pf.os signatures with more recent OS
> fingerprints. I have checked out new Linux, FreeBSD and OpenBSD but only
> Linux and FreeBSD needed new ones. I have been doing this because it is
> related with my work during the last Google Summer of Code. In addition,
> Michal Zalewski is aware of the new fingerprints too.
> 
> Thanks.
> 
> P.S: Keep me on Cc. I'm not subscribed to the list.
> 
> diff --git etc/pf.os etc/pf.os
> index 41c1bc6a482..8f235876799 100644
> --- etc/pf.os
> +++ etc/pf.os
> @@ -232,6 +232,11 @@ S4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6
> (newer, 3)
>  T4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6 (newer, 4)
> 
>  S10:64:1:60:M*,S,T,N,W4:	Linux:3.0::Linux 3.0
> +S10:64:1:60:M*,S,T,N,W6:	Linux:3.1::Linux 3.1
> +S10:64:1:60:M*,S,T,N,W7:	Linux:3.4-3.10::Linux 3.4 - 3.10
> +S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-3.19::Linux 3.11 - 3.19
> +S20:64:1:60:M*,S,T,N,W7:	Linux:4.0-4.19::Linux 4.0 - 4.19

Probably merge these two lines above? ie.

S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-4.19::Linux 3.11 - 4.19

> +S44:64:1:60:M*,S,T,N,W7:	Linux:4.20::Linux 4.20
> 
>  S3:64:1:60:M*,S,T,N,W1:		Linux:2.5::Linux 2.5 (sometimes 2.4)
>  S4:64:1:60:M*,S,T,N,W1:		Linux:2.5-2.6::Linux 2.5/2.6
> @@ -283,6 +288,8 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2
> w/o timestamps
>  65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
>  65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2
> 
> +65535:64:1:60:M*,N,W6,S,T:	FreeBSD:9.0-12.0::FreeBSD 9.0 - 12.0
> +
>  # XXX need quirks support
>  # 65535:64:1:60:M*,N,W0,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (1)
>  # 65535:64:1:60:M*,N,W1,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (2)
