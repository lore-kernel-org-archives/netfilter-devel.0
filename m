From: "Alan Stead" <alan@stead.com>
Subject: getting PID and task name from sk_buff
Date: Wed, 23 Feb 2005 22:17:01 -0800
Message-ID: <DEEDILHNOLKHPLJKLINBOEFHJMAC.alan@stead.com>
Reply-To: alan@stead.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
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
I am trying to get the PID and Task Name from the sk_buff and am having a
hard time doing this.

I have tried the following:
sk_buff->sk->sk_socket->file->fowner.pid
but that always seems to return 0.

I was then planning on using the pid to get the specific task and get the
task->comm to get the name...but I am only getting PID(0): swapper.

Any suggestions on a better way to do this?
I am trying to track network traffic based on the process name and the
process ID.
Thanks!
Alan Stead
