From: Weiguang Shi <wgshi2002@yahoo.ca>
Subject: packet reordering with libipq
Date: Sun, 20 Jun 2004 03:07:44 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040620070744.33536.qmail@web54102.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DeveloperList Netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi

I have a quick question about libipq. 

After I read a packet at  userspace, must I call 
ipq_set_verdict() before I can read another?
In other words, can I re-order packets using libipq?

Thanks,
Weiguang

______________________________________________________________________ 
Post your free ad now! http://personals.yahoo.ca
