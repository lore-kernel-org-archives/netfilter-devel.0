From: Martijn Lievaart <m@rtij.nl>
Subject: Re: c++ linking problems
Date: Thu, 13 Apr 2006 08:44:04 +0200
Message-ID: <443DF334.1070705@rtij.nl>
References: <443D6B0F.3050206@khaletech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jay Hester <jay.hester@khaletech.com>
In-Reply-To: <443D6B0F.3050206@khaletech.com>
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

Jay Hester wrote:

> Hello,
>     This is probably something easy that i'm overlooking, but how do 
> you link in netfilter_queue in to a c++ program?
>
>     I've lightly modified the code in 
> libnetfilter_queue-<vers>/utils/nfqnl_test.c to build a test program. 
> When I try to compile the program i'm getting lots of linking errors 
> like this:
>

If you did:

extern C {
 #include "netfilter_queue.h" // Or whatever C header
 #include "another_C_header.h"
}

I think it should work.

M4
