From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Tue, 31 May 2005 15:02:47 +0200
Message-ID: <429C6077.3060503@trash.net>
References: <20050402202438.GA2968@linuxace.com>
	<1117531044.7878.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1117531044.7878.18.camel@localhost.localdomain>
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

Hi Rusty,

using up your flame early this year? :)

Rusty Russell wrote:
> This is tested in the testsuite, and sure enough, now the patch
> resulting from this discussion has been applied, it fails.  Well done:
> your fix broke FTP worse than the original problem, it seems.

I don't think so. First of all, the original problem was data
corruption, so if my patch didn't blew up your harddisc, it's
hardly worse. Second of all, I spent like 10 hours to verify the
proposed fixes, and I am still convinced that it is correct.

You didn't mention which testsuite fails, so I assume you're
talking about 03NAT/65a-ftp-ack-adjust2.sim. Looking at it,
I'm pretty sure it will start working once you resend the
"Hi Marc\r\n" with every new session, so a newline is present
before the PORT command.

> I *did* ask for a test here, and this is what the testsuite is *for*.
> And now it works on x86_64, there's no excuse.

Great, my excuse now will be that you apparently already wrote one :)

Regards
Patrick
