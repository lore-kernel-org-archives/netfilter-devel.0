From: John Lange <john.lange@open-it.ca>
Subject: Logging process ID
Date: Sat, 16 Jul 2005 14:28:55 -0500
Message-ID: <1121542135.17007.124.camel@ws50.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain
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

Does iptables have the ability (or is there a patch available) to log
the process id that generated a packet that was blocked? Obviously we
are talking about internally generated packets only. This would be
similar to --log-uid.

Google and a quick look through patch-o-matic didn't turn up anything.

This would probably be easy to add wouldn't it?

-- 
John Lange
OpenIT ltd. www.Open-IT.ca (204) 885 0872
VoIP, Web services, Linux Consulting, Server Co-Location
