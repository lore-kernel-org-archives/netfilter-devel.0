From: Kristen Carlson <kristenc@cs.pdx.edu>
Subject: connection destruction question
Date: Wed, 10 Mar 2004 16:51:33 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403110051.i2B0pYU0025941@sirius.cs.pdx.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello,
Is there a way to be notified in a kernel module 
when a connection is destroyed?  I have a nice helper
module that would like to know when connections are destroyed
so it can do some internal cleanup work. 
Thanks,
Kristen
