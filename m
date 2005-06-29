From: Roberto Nibali <ratz@tac.ch>
Subject: possible issues with blowing up struct ipt_log_info
Date: Wed, 29 Jun 2005 17:37:55 +0200
Message-ID: <42C2C053.3040707@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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

Hello,

For our central logging infrastructure we prefix a LOG rule with quite some
information which is not directly available in the ipt_LOG.c module. Plus this
allows our maintenance team to improve reaction time. For that I blew up the
ipt_log_info struct as follows:

-- linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_LOG.h    2000-03-17 19:56
:20 +0100
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_LOG.h    2005-06-29 14:52
:03 +0200
@@ -9,7 +9,7 @@
 struct ipt_log_info {
        unsigned char level;
        unsigned char logflags;
-       char prefix[30];
+       char prefix[126];
 };

 #endif /*_IPT_LOG_H*/

My question is, if anyone sees any problems with this, regarding performance
degradation on 32bit boxes or with caching problems? Does anyone know? A typical
prefix entry for example looks as follows (just in case you'd ask yourself why
we need such a big entry):

`tfx3: fw-tcp [1004] a:ACCEPT s:NEW f:PREROUTING F=NOTRACK '

Where ...

   tfx3          : is the internal firewall version (changes depending on the
                   kernel booted, support from 2.0.x to 2.6.x),
   [1004]        : is the rule number of the meta rule
   a:<aaa>       : is the action taken
   s:<sss>       : is the state
   <f,m,n>:<fmn> : is the table and the chain
   F=<FFF>       : are reserved for the flags passed by the meta fw

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
