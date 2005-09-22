From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: (no subject)
Date: Thu, 22 Sep 2005 16:31:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509221628270.24263@filer.marasystems.com>
References: <87CDEF0BA329934CB1B2A156A90BBF1205BEA2@coyote.columbia.ads.sparta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Heyman, Michael" <Michael.Heyman@sparta.com>
In-Reply-To: <87CDEF0BA329934CB1B2A156A90BBF1205BEA2@coyote.columbia.ads.sparta.com>
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

On Thu, 22 Sep 2005, Heyman, Michael wrote:

> Again, I haven't tested it but I also didn't see where "ip" or "datalen"
> were used in the case where the target did not return IPT_CONTINUE.

You are right. On a second look your patch looks much better.

Regards
Henrik
