From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] note owner match brokenness
Date: Sun, 03 Oct 2004 22:36:31 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416062CF.10709@trash.net>
References: <20041001204447.GA30390@linuxace.com> <415DC791.3060409@trash.net>
	<20041001211251.GA30542@linuxace.com> <415DCC5E.2030407@trash.net>
	<20041003194330.GG2823@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020902070103050108000900"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20041003194330.GG2823@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020902070103050108000900
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Herve Eychenne wrote:

>On Fri, Oct 01, 2004 at 11:30:06PM +0200, Patrick McHardy wrote:
>  
>
>>Agreed, I'm going to apply your patch. Thanks.
>>    
>>
>
>Please apply the same to the manpage!
>  
>
I've applied this patch to the manpages.

Regards
Patrick



--------------020902070103050108000900
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: extensions/libip6t_owner.man
===================================================================
RCS file: /cvsroot/iptables/extensions/libip6t_owner.man,v
retrieving revision 1.1
diff -u -r1.1 libip6t_owner.man
--- extensions/libip6t_owner.man	22 Jan 2004 15:04:24 -0000	1.1
+++ extensions/libip6t_owner.man	3 Oct 2004 20:35:38 -0000
@@ -19,3 +19,5 @@
 .BI "--sid-owner " "sessionid"
 Matches if the packet was created by a process in the given session
 group.
+.TP
+.B NOTE: pid, sid and command matching are broken on SMP
Index: extensions/libipt_owner.man
===================================================================
RCS file: /cvsroot/iptables/extensions/libipt_owner.man,v
retrieving revision 1.1
diff -u -r1.1 libipt_owner.man
--- extensions/libipt_owner.man	22 Jan 2004 15:04:25 -0000	1.1
+++ extensions/libipt_owner.man	3 Oct 2004 20:35:38 -0000
@@ -24,3 +24,5 @@
 Matches if the packet was created by a process with the given command name.
 (this option is present only if iptables was compiled under a kernel
 supporting this feature)
+.TP
+.B NOTE: pid, sid and command matching are broken on SMP

--------------020902070103050108000900--
