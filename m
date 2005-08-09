From: Christoph Hellwig <hch@lst.de>
Subject: tasklist_lock abuse in ipt{,6}owner
Date: Tue, 9 Aug 2005 23:12:49 +0200
Message-ID: <20050809211249.GA29430@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jmorris@namei.org, netfilter-devel@lists.netfilter.org
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

Folks, could you please take a look at getting rid of that match_pid
crap?  We need to get rid of the tasklist_lock export to change the
locking scheme in that area, and what netfilter does with it is not
pretty.  I'd actually prefer dropping those modules completely, this
kind of inverse lookup from file/socket to process shouldn't be done
anywhere in the kernel.
