From: cookie <cookie@iacookie.net>
Subject: Kernel Crash using iptables 1.3.4 and kernel 2.6.15
Date: Wed, 23 Nov 2005 08:57:33 -0500
Message-ID: <C2852E8C-7872-400B-951A-9D5C3B133C2D@iacookie.net>
References: <20051123134501.E418533BE2@crs.ultradns.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20051123134501.E418533BE2@crs.ultradns.net>
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

Hello-
   After upgrading my kernel to 2.6.15-rc2
everything ran fine, then when I upgraded
with iptables 1.3.4, I now get a mysterious
system freeze.
   About 1 in 10 times I get a message flashed
to the console just before it dies.

barney kernel: skb_over_panic: text:00000000005b8ccc len:772 put:772  
head:fffff80067b89400 data:fffff80067b89400 tail:fffff80067b89704  
end:fffff80067b89700 dev:<NULL>

can anyone help me figure this message out?

Thanks
Brian

  
  
