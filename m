From: Todd Underwood <todd@docforge.org>
Subject: Re: changing packet length?
Date: Thu, 12 May 2005 09:25:33 -0600
Message-ID: <20050512152533.GE22646@docforge.org>
References: <20050503213406.GE13894@tigris.renesys.com>
	<20050506111410.GG30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050506111410.GG30482@sunbeam.de.gnumonks.org>
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

Harald, all,

On Fri, May 06, 2005 at 01:14:10PM +0200, Harald Welte wrote:
> On Tue, May 03, 2005 at 05:34:06PM -0400, BJ Premore wrote:
> > So my hopefully simple question is, can packet sizes be
> > changed and then reinjected using ipq_set_verdict?  
> 
> Of course. you just reinject the packet with a different data_len.
> 

this seems not to work.  given the code that was posted, the trivial
case of this fails:  adding 4 bytes of option-1 to the tcp header,
changing the checksum and changing the size.

the data gets corrupted.  

is there some simple bug that i'm not seeing the in the header/data
handling code that was posted.  running tcpdump, i see the same errors
that bj was reporting.

scouring the web i can find *no* examples of anyone changing the size
of the header or the data in ipq userspace processes.  without being
able to do that, interesting things (like a userspace md5 signing
implementation) are obviously not possible.

harald:  did you mean something by 'reinject' other than
ipq_set_verdict, with new data?

todd 
