From: Romp <romp@siil.net>
Subject: Re: problem with iplimit
Date: Sat, 2 Nov 2002 22:15:21 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.43.0211022211570.8826-100000@nuhkija.sise>
References: <20021102112218.E8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sumit Pandya <sumit@elitecore.com>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021102112218.E8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Sat, 2 Nov 2002, Harald Welte wrote:
> > http://lists.netfilter.org/pipermail/netfilter/2002-January/030405.html
>
> romp: does this patch fix your problem?
>

No difference. (2.4.20pre8 + patch-o-matic-20020825 + the-1-line-patch)
I can still go over the limit by retransmiting the initial syn.


romp
