From: Adam Hasselbalch Hansen <ahh@one.com>
Subject: TCP Reset to destination instead of source.
Date: Fri, 13 Jul 2007 15:55:17 +0200
Message-ID: <46978445.10500@one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi.

Suppose someone connects to, say, port 80, and an Apache thread handles 
the connection. Now, httpd expects a couple of new-line terminated 
lines, before it begins figuring out whether this connection sends a 
valid HTTP-request or not. The problem is that this particular client 
never sends a newline, since he expects something different than an 
HTTP-server handling his request (because he is a moron and don't know 
how to configure his particular software to not use port 80). Suppose 
that these requests are pretty frequent, and actually takes a bit of 
resources from the system, since they leave a lot of httpds hanging 
around, waiting for something which never happens.

Now, we would like to filter out these particular requests. Problem is, 
  we can't recognize them until after they've SYN/ACK'ed with httpd (at 
which point, the originating IP is blacklisted). However, in order to 
free the httpd-threads in question, since they're just hanging around 
waiting for a newline which never comes, it could be nice to send them a 
TCP_RESET, whenever we filter and blacklists one of these requests. So 
my question is this:

Is this, to begin with, a reasonable solution?

And, supposing it is, would the way to do it not simply just being to 
add a --reject-with-option, which calls the reject-code, only without 
swapping source and destination? And would this simply be adding a 
suitable option-line in libipt_REJECT.c, an 'if' in send_reset in 
ipt_REJECT.c, handling whether or not the src/dst-swapping sould occur, 
and obviously extend the enum in ipt_REJECT.h?

Thoughts are appreciated.
Adam

P.S. If you need further elaboration, please say so. :)
