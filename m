From: Robert Scott <rbscott@metavize.com>
Subject: Matching on any bit set after masking
Date: Mon, 30 Aug 2004 11:17:34 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41336F3E.2000505@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

When using the -m mark flag, is there any way to match on any bit being 
set after masking the the mark.  In one rule, I set one of the first 
four bits dependent on the source address, and in another I only want to 
match packets that have any of these first four bits  set.

I could do this with multiple rules, but I was hoping there was a way to 
do it with just one.

thanks,

c--
 --rb
<mailto:alex%40samad.com.au>
