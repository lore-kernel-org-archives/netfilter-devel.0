From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: some primitive header questions
Date: Tue, 20 Apr 2004 10:53:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404200615070.29251-100000@filer.marasystems.com>
References: <4083E22B.7010905@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <4083E22B.7010905@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 19 Apr 2004, Ozgur AKAN wrote:

> When I look into "libiptc.c" I see no include commands. In "libip4tc.c" 
> there are 6 includes but nothing releated with libiptc.c. How do 
> libiptc.h, libiptc.c and libip4tc.h interact?

libip4tc.c includes libiptc.c. You need to look a bit further down to find 
this.

libiptc.c contains the functions common to both IPv4 and IPv6.

Regards
Henrik
