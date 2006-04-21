From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Fri, 21 Apr 2006 17:25:20 +0200
Message-ID: <20060421152520.GA10829@localhost.localdomain>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
	<Pine.LNX.4.64.0604201844440.18935@mercury.sdinet.de>
	<4447D839.804@trash.net> <20060420193858.GA24477@sch.bme.hu>
	<4448109A.7010100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Pablo Neira <pablo@netfilter.org>, KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4448109A.7010100@trash.net>
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

On Fri, Apr 21, 2006 at 12:52:10AM +0200, Patrick McHardy wrote:
> KOVACS Krisztian wrote:
> >   Is there any chance of getting the pkg-config related modifications
> > merged as well?
> > 
> >   http://tinyurl.com/mnw9c
> 
> I saw the patch, but didn't apply it because its mostly Harald and
> Pablo who work on that code.
> 
> @Harald, Pablo: any objections against applying this?

No objections from my part, pkg-config is present in most distros AFAIK,
and we needed a way to explicitely set the version dependencies between
libraries.
