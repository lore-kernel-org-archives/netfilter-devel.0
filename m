From: Fabrice MARIE <fabrice@celestix.com>
Subject: Fwd: simple error in extensions/libipt_ROUTE.c extensions/libipt_IMQ.c
Date: Thu, 20 Jun 2002 20:23:24 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206202023.24978.fabrice@celestix.com>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8bit
Cc: Alexey Talikov <alexey_talikov@texlab.com.uz>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Hello,

This mail would be more appropriate in netfilter-devel,
especially if you want the coreteam to notice/fix it.

Have a nice day,

Fabrice.

----------  Forwarded Message  ----------
Subject: simple error in extensions/libipt_ROUTE.c extensions/libipt_IMQ.c
Date: Thu, 20 Jun 2002 16:17:50 +0500
From: Alexey Talikov <alexey_talikov@texlab.com.uz>
To: netfilter@lists.samba.org

Simple error in extensions/libipt_ROUTE.c
line 24 and 127 need change NETFILTER_VERSION to IPTABLES_VERSION
also
extensions/libipt_IMQ.c
line 18 and 87 need change NETFILTER_VERSION to IPTABLES_VERSION
-----------------------------------
mailto:alexey_talikov@texlab.com.uz
BR
Alexey Talikov
FORTEK
-----------------------------------

-------------------------------------------------------

--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators"
       -Unknown
