From: John Lange <john.lange@bighostbox.com>
Subject: --log-uid target?
Date: Fri, 29 Oct 2004 23:07:36 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1099109256.1798.411.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-develop <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Way back in the archives from 2002 I see a patch to add support for
logging of the userid.

Searching high and low and can't find any other reference to this
feature and it does not appear to be in the current iptables or
patch-o-matic downloads.

Did this ever get implemented? How do you use it?

I tried -j LOG --log-uid but it gives an error.

I'm blocking out-bound packets to port 25 to prevent local users from
spamming. However, I'd like to who it is that is attempting to spam and
also be able to watch the logs to make sure legitimate processes are
able to send mail.

Thanks for any help.
-- 
John Lange
