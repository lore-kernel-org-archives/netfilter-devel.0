From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Discrete packaging of experimental modules
Date: Fri, 17 Sep 2004 23:51:28 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <0D0567C424F9F491BBAACF88@[10.169.6.246]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I was considering using the TARPIT module on my Fedora system but it seems 
that to do that I'll need to compile a custom kernel. Seems like part of 
the point of loadable drivers is to avoid this very thing. So is it 
feasible to build and package single netfilter modules the way one does 
drivers? If so, is it also feasible to build and package the userspace part 
as a dynamic library to be pulled into iptables and friends on demand? Or 
is this all on the future roadmap?
