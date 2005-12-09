From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] ip_nat_tftp: Fix expectation NAT.
Date: Fri, 09 Dec 2005 13:57:11 +0100
Message-ID: <43997F27.3070106@ingate.com>
References: <43980FAA.6060608@ingate.com>
	<20051209045520.GB4244@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20051209045520.GB4244@rama.exocore.com>
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

Harald Welte wrote:
> On Thu, Dec 08, 2005 at 11:49:14AM +0100, Marcus Sundberg wrote:
> 
>>this patch fixes the case where the port in an initial TFTP packet
>>is SNATed. Previously the port was never DNATed back for the expected
>>connection.
> 
> This is one of the cases where I'd really appreciate having a nfsim
> test for the testsuite to 
> 1) help understanding the problem
> 2) prevent further regressions
> 
> Would you be willing to provide us with a testcase for nfsim-testsuite?
> Unfortunately we cannot offer anything but bonus points ;)

Well, I'm currently looking at the RTSP patch for 2.6.15, so getting
familiar with nfsim might be useful in any case. I'll have a look.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
