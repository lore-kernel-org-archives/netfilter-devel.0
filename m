From: Amin Azez <azez@ufomechanic.net>
Subject: svn viewcvs quite broken
Date: Wed, 26 Jul 2006 12:38:40 +0100
Message-ID: <ea7k80$4bv$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I'm trying to diff two versions of a file with viewcvs:

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c?r1=4018&r2=4249

and it just gives me bogus errors like:

An Exception Has Occurred

trunk/patch-o-matic-ng/patchlets/connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c:
unknown location


No doubt it is because the file is not in the head any more, but the
specified versions do exist; the two files are each viewable can can be
downloaded for a manual diff.

Sam
