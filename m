From: zhi wang <pangy2004@yahoo.com>
Subject: re: find_appropriate_src() BUG also exist in 2.4.24
Date: Wed, 7 Apr 2004 23:02:23 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040408060223.60904.qmail@web41712.mail.yahoo.com>
References: <20040404223735.GA1334@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOVACS Krisztian <piglet@sch.bme.hu>,
  Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040404223735.GA1334@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Which to this point is not in either 2.4 or 2.6, but looks as though
> it may actually fix the endless loop we seem to be experiencing.
> 
Yes, the patch should work. The problem here is that, although we are sure it
is buggy, the semantic of the find_appropriate_src isn't all that clear. 

Its purpose is ,as stated in the comment, that "if this
srcip/proto/src-proto-part is currently mapped,and that same mapping gives a
unique tuple within the given range, use that". This makes NAT a little
predicatable for some protocols. But I wonder 

1. why we should care about other sessions, or why we must test that
srcip/proto/src-proto-part is currently mapped if that same mapping gives a
unique tuple. 

2. From the comment's words "that same mapping", I agreed that with KOVACS that
maybe the destionation IP of reply tuple should be used.



__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
