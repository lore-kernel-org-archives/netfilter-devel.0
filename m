From: Patrick Schaaf <bof@bof.de>
Subject: Re: new chain after egress for statistical purpose
Date: Thu, 3 Mar 2005 07:14:02 +0100
Message-ID: <20050303061402.GG31334@oknodo.bof.de>
References: <200503022335.09403.pawlakus@oswiecim.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: pawlakus@oswiecim.eu.org
Content-Disposition: inline
In-Reply-To: <200503022335.09403.pawlakus@oswiecim.eu.org>
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

On Wed, Mar 02, 2005 at 11:35:08PM +0100, pawlakus@oswiecim.eu.org wrote:
> I'm just curious why there is no chain after egress? we have lots of 
> chain before ingress, but we can't do accurate statistics of shaped 
> trafic without using some external software.

The reason would probably be that iptables is packet filtering, and one
rarely filters after egress... And that iptables is NOT a traffic accounting
software.

If you want to make it a traffic accounting software: you seem to
understand what it will take. Go for it! (but maybe search a bit,
not neccessarily here on the mailinglist, for already existing
accounting solutions)

best regards
  Patrick
