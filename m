From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [jorge@dti2.net: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up
 hang on one system]
Date: Thu, 13 Nov 2003 15:46:35 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311131544200.20048-100000@filer.marasystems.com>
References: <20031112004700.69796de6.davem@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20031112004700.69796de6.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 12 Nov 2003, David S. Miller wrote:

> On Wed, 12 Nov 2003 09:33:57 +0100
> Harald Welte <laforge@gnumonks.org> wrote:
> 
> > Since there is now a second bug report on that 'fix', I think it's
> > better to back it out for 2.4.23.  The code has been without that 'fix'
> > for the whole 2.4.x time, and it didn't seem to cause any real problem.
> > 
> > So rather than fixing the theoretical case, I'd say we keep the code
> > like before (please revert the below patch) and make user complaints go
> > away.
> > 
> > We'll try to investigate this further, but not before 2.4.23.

It would probably be good to move the patch (74_nat-range-fix.patch) out
from submitted to extra or pending to reflect the current status of this
patch.

Regards
Henrik
