From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 0/6] H.323: implement a "real" H.245 parser
Date: Wed, 11 May 2005 00:50:19 +0200
Message-ID: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

the following patchset replaces Jozsef's "brute force" parser with a
real H.245 parser. It adds a very simple ASN.1/PER parsing library,
and parses very few H.245 structures (enough for all H.323 software I
tested).

My next task will be the rewrite of the H.225 parser using my
ASN.1/PER library.

Max
