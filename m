From: jamal <hadi@cyberus.ca>
Subject: Re: tc filtering vs iptables
Date: 27 Aug 2004 17:03:55 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093640635.14189.81.camel@jzny.localdomain>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
	<1093638474.14190.29.camel@jzny.localdomain>
	<20040827204205.GB4797@sch.bme.hu>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>,
	"Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
In-Reply-To: <20040827204205.GB4797@sch.bme.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-08-27 at 16:42, KOVACS Krisztian wrote:
>   Hi,
> 
> On Fri, Aug 27, 2004 at 04:27:54PM -0400, jamal wrote:
> > What a painful experience it is to install large rules.
> > about 20 minutes to install 16K rules. Not sure if this is
> > even worth pursuing anymore
> 
>   You're using the 'iptables' command, I guess. Probably you should try
> iptables-restore, it is definitely _the_ tool you'll need when installing
> large rulesets.

One of my tests is to add and delete a rule while traffic is running
(and 16K rules are already installed).
I cant use restore in that case unfortunately -  getting
some very odd behavior just adding and deleting the rule. 

cheers,
jamal
 
