From: David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.20-rc4
Date: Mon, 08 Jan 2007 23:39:54 -0800 (PST)
Message-ID: <20070108.233954.84364479.davem@davemloft.net>
References: <45A2C6AE.5080400@trash.net> <m3ps9pp1fd.fsf@telia.com>
	<Pine.LNX.4.64.0701081511340.3661@woody.osdl.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: petero2@telia.com, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: torvalds@osdl.org
In-Reply-To: <Pine.LNX.4.64.0701081511340.3661@woody.osdl.org>
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

From: Linus Torvalds <torvalds@osdl.org>
Date: Mon, 8 Jan 2007 15:12:08 -0800 (PST)

> 
> 
> On Mon, 9 Jan 2007, Peter Osterlund wrote:
> > 
> > Thanks, the patch appears to help. The kernel has now survived much
> > longer with this patch than it used to do without it.
> > 
> > I will recompile with gcc 4.1.1 too just to make sure, but if you
> > don't hear anything more from me, consider the case closed. :)
> 
> David - I assume I'll get this patch through you, and I can just forget 
> about this issue and go about my normal mindless ways?

Yep, I'll push it to you very soon.

Thanks Patrick for figuring this bug out, nice work.
