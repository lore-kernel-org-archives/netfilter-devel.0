From: Richard Bishop <R.J.Bishop@exeter.ac.uk>
Subject: RE: NF_QUEUE examples
Date: Fri, 16 Apr 2004 09:23:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407FC8AD@minerva.ex.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ulysses Almeida wrote:

> where can i find simple examples of using it?

Given that there are two parts to the ip_queue system (namely the userspace 
and kernelspace parts), I tried Googling on 'libipq example' and came up with 
quite a few userful pages.

There is an example in the man page for libipq, an online version of which I 
found at http://www.cs.princeton.edu/~nakao/libipq.htm - I used this example 
when I was playing with it a few weeks back so can confirm that it works ok.

Have a look through the list archives too - this must be a very common 
question.  A list poster back in May 2000 was advised 'In cvs, have a look at 
intercept.c in testsuite/tools and ipq_client.c in OLD/tools.' 
http://lists.netfilter.org/pipermail/netfilter/2000-May/004253.html

Hope this helps.

Regards


Richard

__________________________
Richard Bishop
Department of Computer Science
University of Exeter. UK
