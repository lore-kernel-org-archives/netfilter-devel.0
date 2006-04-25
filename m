From: "=?windows-1251?Q?noip?=" <noip@webhost66.com>
Subject: kernel panic with connlimit and 2.6.16.* kernels
Date: Tue, 25 Apr 2006 10:52:58 +0000
Message-ID: <20060425105258.9430.qmail@webhost66.com>
Reply-To: =?windows-1251?Q?noip?= <noip@webhost66.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1251"
Content-Transfer-Encoding: 8bit
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

Hello,

I've described my problem in the linux kernel list here:
http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1472.html

There I've recieved a reply from Patrick McHardy:
http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1666.html

I've used a patch for connlimit from this thread, because without the patch i can't apply the connlimit patch from the latest patch-o-matic-ng snapshot to any 2.6.16 kernel:
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3456

I've recompilled my kernel without the connlimit patch and the problem is gone now.
Can you tell me is the connlimit patch usable with any of the 2.6.16 kernels at this moment ? 

Thank You 
Iavor  
