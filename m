From: Ahmad Almulhem <feltah@yahoo.com>
Subject: ip_queue question
Date: Fri, 20 Feb 2004 14:51:56 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220225156.40182.qmail@web13422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi all,

I am trying to run 2 program to
use ip_queue module at the same time. 

I basically start the first program 
and it runs fine receiving packets 
correctly. I then run the second 
program, which prints the following 
error:

"Received error message 16"

and keeps running without receiving
any packets!

The two programs that I am running are
snort inline and my code based on the
sample which comes with libipq(3).
Both programs runs fine when run alone.
I only get this problem when I try to run
them together.

My question: does libipq module support
more than one program at one time? is
there any options I should set when
modprobe ip_queue?

thank u for ur help,

ahamd


__________________________________
Do you Yahoo!?
Yahoo! Mail SpamGuard - Read only the mail you want.
http://antispam.yahoo.com/tools
