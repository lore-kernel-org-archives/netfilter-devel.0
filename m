From: "Alan Stead" <alan@stead.com>
Subject: Getting PID from sk_buff
Date: Thu, 24 Feb 2005 22:43:53 -0800
Message-ID: <DEEDILHNOLKHPLJKLINBIEFNJMAC.alan@stead.com>
References: <20050224162709.GC5056@oknodo.bof.de>
Reply-To: alan@stead.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codeslinger@gmail.com, netfilter-devel@lists.netfilter.org
To: "Patrick Schaaf" <bof@bof.de>
In-Reply-To: <20050224162709.GC5056@oknodo.bof.de>
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

I think I will try the system call approach, but I would also like to add a
process-name match.

I have looked at the pid-owner match, however I dont have a pid to go by,
and it seems ridiculous to go through all the tasks, find a matching name,
and then go through that task's files to find a match.  Instead I was trying
to get the process pid from the sk_buff through:
sk_buff->sk->sk_socket->file->f_owner.pid
but it always returns 0...?

Alan Stead
