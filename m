From: ofudd@psdhost.net
Subject: [TYPO] patch to cvs libipt_string.c
Date: Mon, 28 Apr 2003 15:29:31 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304281524370.22672-100000@blimp.psdhost.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I downloaded iptables from CVS today, enabled the string matching
feature, and tried to compile the userspace tools.  Compilation failed
due to a typo.

In ./netfilter/userspace/extensions/libipt_string.c:

205c205
< 	printf("--string %s%s ", (info->invert) ? "! ", "", info->string);
---
> 	printf("--string %s%s ", (info->invert) ? "! ": "", info->string);

--
ofudd@psdhost.net
