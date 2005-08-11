From: Christoph Hellwig <hch@lst.de>
Subject: Re: tasklist_lock abuse in ipt{,6}owner
Date: Thu, 11 Aug 2005 17:24:50 +0200
Message-ID: <20050811152450.GA8189@lst.de>
References: <20050809211249.GA29430@lst.de> <42FB449A.7030709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42FB449A.7030709@trash.net>
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

On Thu, Aug 11, 2005 at 02:29:14PM +0200, Patrick McHardy wrote:
> Christoph Hellwig wrote:
> > Folks, could you please take a look at getting rid of that match_pid
> > crap?  We need to get rid of the tasklist_lock export to change the
> > locking scheme in that area, and what netfilter does with it is not
> > pretty.  I'd actually prefer dropping those modules completely, this
> > kind of inverse lookup from file/socket to process shouldn't be done
> > anywhere in the kernel.
> 
> I think its ok to rip out cmd/sid/pid matching, it is broken and can't
> be fixed anyway. Feel free to send a patch, otherwise I'll take care
> of it.

So you want to keep the uid/gid matches for now?  Probably we should
check for the others in ->checkentry then and refuse to load if they're
present?
