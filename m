From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [netfilter-core] 2.6.9-rc1: missing netfilter help texts
Date: Wed, 1 Sep 2004 18:31:49 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040901183149.648325a3.davem@davemloft.net>
References: <Pine.LNX.4.58.0408240031560.17766@ppc970.osdl.org>
	<20040831173425.GE3466@fs.tum.de>
	<20040831184000.GO5824@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: torvalds@osdl.org, netfilter-devel@lists.netfilter.org, bunk@fs.tum.de,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040831184000.GO5824@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 31 Aug 2004 20:40:00 +0200
Harald Welte <laforge@netfilter.org> wrote:

> On Tue, Aug 31, 2004 at 07:34:25PM +0200, Adrian Bunk wrote:
> > The following new netfilter options lack help texts:
> > - IP_NF_CT_ACCT
> > - IP_NF_MATCH_SCTP
> > - IP_NF_CT_PROTO_SCTP
> > 
> > Could someone add the help texts?
> 
> Patch to add help texts attached, as well as a second, incremental patch
> to sort entries into reasonable order
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied, thanks Harald.
