From: "Bryan Graham" <urza@tca.net>
Subject: Queue Problems
Date: Wed, 25 Jun 2003 00:18:46 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <MLEDKOOODKMPNABFJPOACEHKCAAA.urza@tca.net>
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

	I seem to be having a problem with user space queueing.  Basically,
regardless of what I have the queue size set to (I am currently using the
default 1024), whenever I set the verdict of a packet (using
ipq_set_verdict) when the queue size is over 255, the queue seems to be
flushed.  I put a printk into the ip_flush function, so I know that it isn't
flushed via that function.  I am currently using 2.4.18-3 (Redhat 7.3).  Has
anyone else ever seen a problem like this?

thanks,
Bryan Graham
