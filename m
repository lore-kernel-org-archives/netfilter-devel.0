From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 6 May 2004 12:12:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405061211230.29759-100000@filer.marasystems.com>
References: <20040505065402.GA18440@hamachi.radom.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dan radom <netfilter@radom.org>
In-Reply-To: <20040505065402.GA18440@hamachi.radom.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 5 May 2004, dan radom wrote:

> This bug has been open for quite some time, and bugzilla doesn't really
> shows much beyond the initial bug report.  Is this something that will
> ever work?  I would love to use this feature on sparc64.

It requires some clever guy with a sparc64 to come up with a scheme how to 
make user and kernel data types compatible in a 32/64 split user/kernel 
environment.

Regards
Henrik
