From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/5] NAT simplifications
Date: Thu, 18 Nov 2004 16:37:23 +1100
Message-ID: <1100756244.5865.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

Hi all,

	I've been digging through my patch collection, and there are some
significant NAT ones which I've updated.  Mainly they simplify the NAT
code, which I think is important since this area has been something of a
quagmire (although I was delighted to find Krisztian Kovacs is brave
enough to bugfind here).

Thoughts and test results welcome...
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
