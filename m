From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: tc filtering vs iptables
Date: Fri, 27 Aug 2004 22:42:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040827204205.GB4797@sch.bme.hu>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
	<1093638474.14190.29.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>,
	"Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
Content-Disposition: inline
In-Reply-To: <1093638474.14190.29.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Fri, Aug 27, 2004 at 04:27:54PM -0400, jamal wrote:
> What a painful experience it is to install large rules.
> about 20 minutes to install 16K rules. Not sure if this is
> even worth pursuing anymore

  You're using the 'iptables' command, I guess. Probably you should try
iptables-restore, it is definitely _the_ tool you'll need when installing
large rulesets.

-- 
 KOVACS Krisztian
