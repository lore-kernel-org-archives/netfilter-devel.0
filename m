From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: set MARK patch for QUEUE target
Date: Thu, 20 Feb 2003 17:38:21 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <012401c2d8aa$a957aad0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

A while back someone released a patch to allow a userspace process to set
the nf_mark by way of a function called ipq_set_mark from inside ip_queue.c
and there was some debate over whether this was the right way to do it or
not. Can someone please enlighten me as to the outcome of whether it is
infact safe to add this patch or if it's been done a different way since
because I'd like to be able to do this if possible.

Thanks,

Andrew.
