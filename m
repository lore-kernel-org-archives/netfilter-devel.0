From: Wang Jian <lark@linux.net.cn>
Subject: Improve POM error message
Date: Wed, 30 Mar 2005 23:01:55 +0800
Message-ID: <20050330225916.0198.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
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

Hi,

Here is a one liner patch agains Netfilter_POM.pm which improves error
message. This patch will give more clear information in the situation
that there are multiple lineadd files for a single file.


Index: Netfilter_POM.pm
===================================================================
--- Netfilter_POM.pm    (revision 3808)
+++ Netfilter_POM.pm    (working copy)
@@ -630,7 +630,7 @@
        close(SRC);
                
        if ($found == 0) {
-               $self->{ERRMSG} .= "unable to find ladd slot in src $srcfile\n";
+               $self->{ERRMSG} .= "unable to find ladd slot in src $srcfile ($laddfile)\n";
                return 0;
        } elsif (!$test && $found == -1) {
                $self->{ERRMSG} .= "unable to find all to-be-removed lines in $srcfile\n";



-- 
  lark
