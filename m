From: Dan Aloni <da-x@gmx.net>
Subject: Re: '-m owner' problem (bug?)
Date: Fri, 20 Sep 2002 18:31:51 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920153151.GA11251@callisto.yi.org>
References: <20020918170408.GA12455@callisto.yi.org> <20020920170513.L3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20020920170513.L3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Sep 20, 2002 at 05:05:13PM +0200, Harald Welte wrote:
> On Wed, Sep 18, 2002 at 08:04:08PM +0300, Dan Aloni wrote:
> > (not subscribed to the list, please CC)
> > 
> > This command used to work in the past:
> > 
> >    iptables -A OUTPUT -o eth1 -m owner --uid-owner 0 -d 192.168.1.6/32 -j
> >    ACCEPT
> 
> can you try to recompile the latest iptables package (1.2.7a) and see if
> the problem persists?
> 
> This is not supposed to be the solution, I just want to know where the 
> problem comes from...

Apparently, the problem comes from me. I compiled iptables without
specifing KERNEL_DIR= to the location of the 2.4.20-pre7 source tree.

I was assuming that the Makefile would pickup /lib/modules/`uname -r`/build,
but now I see that it defaults to /usr/src/linux.

Well, it works now. Thanks.

-- 
Dan Aloni
da-x@gmx.net
