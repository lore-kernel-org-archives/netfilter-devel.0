From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] corrected ROUTE target
Date: Fri, 25 Jul 2003 13:36:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.52.0307251336050.5863@tux.rsn.bth.se>
References: <1056465726.2457.30.camel@descartes>  <1058517461.25182.139.camel@descartes>
  <1058724909.8305.307.camel@tux.rsn.bth.se> <1059126202.17206.15.camel@descartes>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1059126202.17206.15.camel@descartes>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jul 2003, Cedric de Launois wrote:

> Ok. So here is the ROUTE patch that preserves the old behaviour.
> The new option is called --continue. When using it, the packet is routed
> and then continues travering the rules. If the option is not used, the
> behaviour is as before (i.e. the packet is sent).
>
> The patch is against current cvs.

Applied, thanks

/Martin
