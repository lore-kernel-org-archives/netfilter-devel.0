From: Roberto Nibali <ratz@tac.ch>
Subject: [PATCH 2.4.x][RFC] enlarge struct ipt_log_info prefix to 62 bytes
Date: Mon, 20 Dec 2004 12:55:51 +0100
Message-ID: <41C6BDC7.8060507@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hello,

I'm in progress of my annual christmas code cleaning round and during this time 
I always send back all the patches that could be useful to others or might be 
included without major impact to the respective OSS projects and maintainers.

Concerning netfilter there is one I think others might "benefit" from as well. 
Here's the patch we're using to enlarge the prefix member of the struct 
ipt_log_info structure in ipt_LOG.h:

  struct ipt_log_info {
         unsigned char level;
         unsigned char logflags;
-       char prefix[30];
+       char prefix[62];
  };

We need those additional 32 bytes to represent the prepended text of our meta 
firewall rule composition engine. As an more or less illustrative example, we 
use something as follows:

META_LOG_MSG="foobar: ${META_NAME} [${META_RULE_NUMBER}] a:${ACTION} \
          s:${STATE} f:${META_ICHAIN} "

${IPTABLES} -t filter -A ${META_ICHAIN} -j ${IPT_LOG} \
             [...] \
             ${IPT_LOG_LEVEL} ${IPT_LOG_PREFIX} "${META_LOG_MSG}" \
             [...]

This is in order to do proper and fast log correlation and apply general data 
mining algorithms for classification. Anyway, more information is available on 
request.

I simply wanted to ask if this patch is acceptable both for 2.4.x and 2.6.x 
mainline inclusion or if I'm really off limits. At least it's cache line aligned 
:). We maintain a couple of other ipt_LOG.c patches which help log correlation, 
which however are rather not suitable for submission.

Getting as many patches as possible back to the community reduces my patch 
maintainance and forward patching time.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
