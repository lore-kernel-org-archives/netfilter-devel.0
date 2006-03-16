From: <reiner.siberg@bredband.net>
Subject: rtsp-conntrack & kernel 2.6.10
Date: Thu, 16 Mar 2006 9:49:25 +0100
Message-ID: <20060316084925.QBME16061.mxfep01.bredband.com@mxfep01>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I am new to netfiltering but still trying to use the rtsp-conntrack with 
the 2.6.10 kernel.

I have found two versions of rtsp-conntrack, one old(?) and one for 2.6.11.
As I understand there has been some changes in the netfilter API's
between 2.6.10 and 2.6.11. 

The question is if I should backport the 2.6.11 version or try to 
add the possible bugfixes to the old one, what is recommended
(I think I will be stuck with the 2.6.10 kernel for a while)? 

Regards
