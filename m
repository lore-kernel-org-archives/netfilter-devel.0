From: "Richard" <richard@o-matrix.org>
Subject: RE: check timer active
Date: Sun, 5 Dec 2004 11:47:26 -1000
Message-ID: <EINSTEIN4FR0rmTIVvL000068ca@einstein.systemmetrics.com>
References: <41B37E2F.4020007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	'Henrik Nordstrom' <hno@marasystems.com>,
	'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Patrick McHardy'" <kaber@trash.net>, "'Pablo Neira'" <pablo@eurodev.net>
In-Reply-To: <41B37E2F.4020007@trash.net>
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

> 
> Pablo Neira wrote:
> 
> > still think that you should use that function.
> >
> > Hm, I just realized that the amanda helper is faking counters, I guess
> > that we need a version of ip_ct_refresh_acct which doesn't the
> > increase skb counters. I'll send a patch to fix this once I know what
> > is scheduled with nf_conntrack.

I only saw ip_ct_refresh. What's the difference between ip_ct_refresh_acct
and it?

Richard
