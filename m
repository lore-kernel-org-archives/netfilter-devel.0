From: Peter Enderborg <pme@ufh.se>
Subject: ip_queue questions
Date: Sat, 26 Mar 2005 08:08:46 +0100
Message-ID: <42450A7E.8050404@ufh.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
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

Is there any non trivial example of howto use netlink?
A non trivial is something that use do something with the packet and 
returns a modifyed packet form userland.
And is there any way to do matching rule in userland? ipq_set_verdict() 
must have NF_ACCEPT or NF_DROP.
I whould like to do something similar to the MARK, just modify the data 
and then continue.


-- 
foo!
