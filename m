From: "Zachary Link" <zack@the-links.net>
Subject: src/dest wilcard matching
Date: Wed, 15 Sep 2004 10:06:06 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <54512.139.76.128.1.1095257166.squirrel@www.the-links.net>
Reply-To: zack@the-links.net
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: zack@the-links.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I am looking for the ability to use wilcards or regexp type matching for
source and destination fields.  Maybe this could be an extension or
something...

For example
--source 172.*.*.1
or
--destination 10.[1-10].[10|20].1

Picture, if you will, a situation where you had 1,000 offices all on
10.x.y.0/24 networks.  All routers might be 10.x.y.1.  You might want to
give your network guys access to just those devices, and sysadmins access
to all servers at 10.x.y.10-19 or any other types of devices sitting on
these networks.

So, the biggest hurdle I need to overcome is to allow arbitrary middle
octets while matching 1st and last octet.  I was looking through the docs
and I found that something like this could be done with the u32 extensions
(I think), but it would be very cumbersome, and not easy to use.  I also
took a look at the code and realized there is no way to do it myself as I
have no real knowledge of C (I'll look like an idiot here if that's not C 
;-).

So, am I missing some existing functionality that would allow for that? 
Or, does anyone have any desire to develop that sort of feature?

Thanks all,

Zack
