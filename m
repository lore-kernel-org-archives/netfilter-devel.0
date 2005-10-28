From: Daniel Ivanov <sertys@supportivo.org>
Subject: Additional arguments to a module
Date: Fri, 28 Oct 2005 06:58:32 +0300
Message-ID: <4361A1E8.6070405@supportivo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251; format=flowed
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

I want to add an additional argument to the ipt_MARK.c module.
Where do i register that one? I would like a check for true/false(0/1) 
on that argument and different return code accordint to the value.
like :
iptables -t mangle -A PREROUTING -j MARK --set-mark 5 --my 1
 to be acceptable.
I suppose it has to do with targinfo , but don't know how to act 
further. Any clues appreciated.
