From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: Thu, 3 Apr 2003 13:15:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030403111505.GC656@eychenne.org>
References: <20030403025151.GA1702@pc.ilinx> <1049364942.25148.60.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter@interlinx.bc.ca,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1049364942.25148.60.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Apr 03, 2003 at 12:15:43PM +0200, Martin Josefsson wrote:

> Thanks for the report, I'll try to fix it up.

> The answer is that I don't have time to check all the time if everything
> still applies after new stuff has been added to pom.

The best way is probably to have some scripts run regularly, trying
some patch-o-matic combinations (why not all, as patch is quite
fast...) to detect incompatibilities automatically, and especially
report new ones.
Such a list would be interesting.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
