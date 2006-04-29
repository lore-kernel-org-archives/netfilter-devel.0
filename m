From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Sat, 29 Apr 2006 02:53:48 +0200
Message-ID: <200604290253.49758.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it> <200604281718.16912@nienna>
	<445235FE.9040203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <445235FE.9040203@trash.net>
Content-Disposition: inline
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

On Friday 28 April 2006 5:34 pm, Patrick McHardy wrote:

> Hehe :) Yes, its not nice, but I refuse to add stupid limits just
> because the infrastructure can't cleanly support per-instance state
> (which is what makes it ugly, its not the shared state). And its not
> so bad, the uglyness comes down to two or three extra lines of code,
> one additional pointer in the data structure and one offsetof in
> userspace.

Nontheless, I think modifying userspace because 2 kernel functions can't talk 
to each other is a bit silly.
It would be relatively easy to modify the kernel in order to support instance 
data (extensive, but simple and relatively safe).
Do you think there would be a strong resistance to a patch in mainline kernel?

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
