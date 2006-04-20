From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Thu, 20 Apr 2006 21:38:58 +0200
Message-ID: <20060420193858.GA24477@sch.bme.hu>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
	<Pine.LNX.4.64.0604201844440.18935@mercury.sdinet.de>
	<4447D839.804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-return: prohibited
In-reply-to: <4447D839.804@trash.net>
To: netfilter-devel@lists.netfilter.org
Content-disposition: inline
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

On Thu, Apr 20, 2006 at 08:51:37PM +0200, Patrick McHardy wrote:
> > Shouldn't --with-kernel let me specify a kernel source directory,
> > instead of a kernel version and then using some heuristicts to find the
> > source directory? (The heuristic for the default using
> > /lib/modules/`uname -r`/build is fine)
> 
> I agree, if someone sends me a patch to change it I'll apply it.

  Is there any chance of getting the pkg-config related modifications
merged as well?

  http://tinyurl.com/mnw9c

-- 
 KOVACS Krisztian
