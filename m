From: Guillowind@aol.com
Subject: Re: string patch for 2.6
Date: Sat, 01 Jan 2005 17:03:43 -0500
Message-ID: <7EC9EED7.6601B8AC.0B9ABE5A@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: jnk@pwn.emphyrio.org (Dimitris Kotsonis),
	netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Perhaps Im going about this the wrong way but Im trying to apply this patch I'd really like to use string patch for 2.6 kernel.

But I get 
patch -p0 < /usr/src/redhat/SOURCES/kernel-2.6-string.patch
can't find file to patch at input line 4
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff -urN patch-o-matic-ng-20041229.orig/string/info patch-o-matic-ng-20041229/string/info
|--- patch-o-matic-ng-20041229.orig/string/info  2004-02-20 01:55:30.000000000 +0200
|+++ patch-o-matic-ng-20041229/string/info   2004-12-30 09:45:42.000000000 +0200
--------------------------
File to patch:

when I attempt this, can anyone clarify the next step for me, if I specify the listed file with a full path, then I get another error about line 5 concerning the authors name and so on.

I'd like to get new kernels and iptables rpms built with this patch can anyone clarify this for me

Thanks.
