From: Eugene Prokopiev <prokopiev@stc.donpac.ru>
Subject: Simple nat module example
Date: Thu, 05 Apr 2007 16:14:22 +0400
Message-ID: <4614E81E.4050806@stc.donpac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Can anybody give me a simple nat module example without connection 
tracking support (and may be with comments) for kernel 2.6.18? I tried 
to read "Netfilter Hacking HOWTO" and "Netfilter connection tracking and 
nat helper modules" from http://netfilter.org/documentation/index.html, 
but they are using ip_nat_helper structure which I can't find in kernel 
source :( All nat modules included in kernel 2.6.18 uses connection 
tracking so they are difficult to understand for beginner :(

--
Thanks,
Euegene Prokopiev
