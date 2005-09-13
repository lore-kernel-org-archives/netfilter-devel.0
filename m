From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH 2/3] CLUSTERIP: introduce reference counting for entries
Date: Tue, 13 Sep 2005 17:16:57 +0200
Message-ID: <200509131716.57282@nienna>
References: <20050830121535.985929000@nienna.balabit>
	<200508301726.08506@nienna>
	<20050913125405.GR29695@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20050913125405.GR29695@sunbeam.de.gnumonks.org>
Content-Disposition: inline
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


  Hi,

On Tuesday 13 September 2005 14.54, Harald Welte wrote:
> On Tue, Aug 30, 2005 at 05:26:07PM +0200, KOVACS Krisztian wrote:
> > On Tuesday 30 August 2005 16.07, Harald Welte wrote:
> > > Thanks for your patches 2 and 3.  I want to review them in more
> > > detail and need to re-read the CLUSTERIP code first.  Expect some
> > > feedback in the next two days.
> >
> >   OK, thanks. BTW, I've just found a serious bug in patch 2, I knew
> > I was missing something... So please apply this on top of patch 2.
>
> as usual, the two days got a bit long.  But now I've reviewed the old
> code and your changes.  I've applied them to my git tree with some
> minor modifications/clarifications.

  Thanks a lot. One more thing: what's up with the updated CLUSTERIP 
userspace?
 
http://lists.netfilter.org/pipermail/netfilter-devel/2005-August/021165.html

-- 
 Regards,
  Krisztian Kovacs
