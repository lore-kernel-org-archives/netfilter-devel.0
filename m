From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] update to ROUTE target
Date: 25 Jul 2003 17:27:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059146872.675.0.camel@tux.rsn.bth.se>
References: <1056465726.2457.30.camel@descartes>
	 <1058517461.25182.139.camel@descartes>
	 <1058724909.8305.307.camel@tux.rsn.bth.se>
	 <1059126202.17206.15.camel@descartes>
	 <Pine.LNX.4.52.0307251336050.5863@tux.rsn.bth.se>
	 <1059138966.17205.31.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1059138966.17205.31.camel@descartes>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-07-25 at 15:16, Cedric de Launois wrote:
> Hi again,
> 
> Oops, I forgot to also submit changes to the ROUTE.patch.configure.help
> and ROUTE.patch.help files to update the descriptions of the target.
> 
> I also modified ROUTE.patch.configure.in in order to make the ROUTE
> target dependent of the CONFIG_IP_NF_MANGLE kernel option (since the
> ROUTE target must be used inside the mangle table).
> 
> The patch is still against the very current cvs.
> 
> Thanks for applying it.

Applied

-- 
/Martin
