From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Update pf.os with newer OS fingerprints
Date: Fri, 8 Feb 2019 17:45:38 +0100
Message-ID: <20190208164538.aal6txzirvse2uym@salvia>
References: <7d39a0dc-d7bd-7934-1d86-7268bf7c51b9@riseup.net>
 <20190208160725.aen3uil2jmfnp6zc@salvia>
 <26083325-457a-1a4d-6aff-935d887d6478@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: tech@openbsd.org, netfilter-devel@vger.kernel.org
To: Fernando Fernandez Mancera <ffmancera@riseup.net>
Return-path: <owner-tech+M68998=goot+2Dtech=gmane.org@openbsd.org>
Content-Disposition: inline
In-Reply-To: <26083325-457a-1a4d-6aff-935d887d6478@riseup.net>
List-Help: <mailto:majordomo@openbsd.org?body=help>
List-Owner: <mailto:owner-tech@openbsd.org>
List-Post: <mailto:tech@openbsd.org>
List-Subscribe: <mailto:majordomo@openbsd.org?body=sub%20tech>
List-Unsubscribe: <mailto:majordomo@openbsd.org?body=unsub%20tech>
Sender: owner-tech@openbsd.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 08, 2019 at 05:25:38PM +0100, Fernando Fernandez Mancera wrote:
[...]
> On 2/8/19 5:07 PM, Pablo Neira Ayuso wrote:
[...]
> > On Fri, Feb 08, 2019 at 03:06:00PM +0100, Fernando Fernandez Mancera wrote:
[...]
> >> +S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-3.19::Linux 3.11 - 3.19
> >> +S20:64:1:60:M*,S,T,N,W7:	Linux:4.0-4.19::Linux 4.0 - 4.19
> > 
> > Probably merge these two lines above? ie.
> > > S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-4.19::Linux 3.11 - 4.19
> > 
> 
> I split this one by following the pattern of similar situations for
> other fingerprints. eg.
> 
> 16384:64:1:44:M*:		FreeBSD:2.0-2.2::FreeBSD 2.0-4.2
> 16384:64:1:44:M*:		FreeBSD:3.0-3.5::FreeBSD 2.0-4.2
> 16384:64:1:44:M*:		FreeBSD:4.0-4.2::FreeBSD 2.0-4.2
> 
> 65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
> 65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2
> 
> In my opinion I would make no changes to these two lines. Do you agree?

That's fine. Thanks for explaining.
