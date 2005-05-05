From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Kill lockhelp.h
Date: Thu, 5 May 2005 16:54:54 -0700
Message-ID: <20050505165454.610e3bd8.davem@davemloft.net>
References: <427AADED.8050301@trash.net>
	<20050505164523.0d9d5cf7.davem@davemloft.net>
	<427AB3D2.7080409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <427AB3D2.7080409@trash.net>
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

On Fri, 06 May 2005 02:01:22 +0200
Patrick McHardy <kaber@trash.net> wrote:

> David S. Miller wrote:
> > Is there a nf_debug death patch coming as well?
> 
> Yes, I thought I'd hold onto it until 2.6.13 because there are no
> problems with the code, but here it is.

The nf_debug issue came to light due to a build failure, didn't
it?

Anyways, I've put this into my "thinking about 2.6.12" queue
as well.

Thanks a lot Patrick.
