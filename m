From: pawlakus@oswiecim.eu.org
Subject: Re: new chain after egress for statistical purpose
Date: Thu, 3 Mar 2005 11:20:55 +0100 (CET)
Message-ID: <57712.62.87.185.5.1109845255.squirrel@oswiecim.eu.org>
References: <200503022335.09403.pawlakus@oswiecim.eu.org>
	<20050303061402.GG31334@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050303061402.GG31334@oknodo.bof.de>
To: "Patrick Schaaf" <bof@bof.de>
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

> The reason would probably be that iptables is packet filtering, and one
> rarely filters after egress... And that iptables is NOT a traffic
> accounting software.

I disagree with that. iptables is good for everything, rule counters
are not only for debugging purposes, but mainly for gathering information=
.
Just to point that there is ipt_ACCOUNT in pom-ng, but still useless on
OUTPUT/POSTROUTING chains before egress (if we shape traffic).

> If you want to make it a traffic accounting software: you seem to
> understand what it will take. Go for it! (but maybe search a bit,
> not neccessarily here on the mailinglist, for already existing
> accounting solutions)

Best place for accounting is in the kernel, it's the only way to
use MARKs, CONNMARKs, etc. so iptables is 'a natural choice'. and it's
good for this job. just lacks of hopefully-last-chain-before-wire ;)

Best regards,
Paul
