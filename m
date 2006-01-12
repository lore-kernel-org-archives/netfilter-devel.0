From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] nfsim: Support more netfilter modules
Date: Thu, 12 Jan 2006 11:25:43 +0100
Message-ID: <43C62EA7.5020001@ingate.com>
References: <439ED1C5.7070103@ingate.com>
	<20060106144048.GE4898@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060802010905010704090909"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060106144048.GE4898@sunbeam.de.gnumonks.org>
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

This is a multi-part message in MIME format.
--------------060802010905010704090909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> On Tue, Dec 13, 2005 at 02:51:01PM +0100, Marcus Sundberg wrote:
> 
>>this patch adds nfsim support for building most of the netfilter stuff
>>in 2.6.15. The things still not compiling are CONFIG_IP_NF_CONNTRACK_NETLINK
>>and CONFIG_IP_NF_MATCH_STRING
> 
> thanks, applied.

Hi,

the patch contained a bogus msleep() implementation, please accept
the following correction.

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/

--------------060802010905010704090909
Content-Type: text/x-patch;
 name="nfsim-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfsim-2.diff"

[NFSIM] Implement msleep() better

There's no point in actually sleeping in the nfsim framework,
just increment time properly.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>


--- nfsim/kernelenv/include/kernelenv.h	(revision 6395)
+++ nfsim/kernelenv/include/kernelenv.h	(working copy)
@@ -1231,7 +1231,7 @@
 
 /* delay.h */
 
-#define msleep(x)	do{unsigned int y = (x)*1000; usleep(y);}while(0)
+#define msleep(x)	increment_time((x)*HZ/1000)
 
 /* timer.h */
 

--------------060802010905010704090909--
