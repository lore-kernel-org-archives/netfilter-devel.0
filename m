From: switcher <switcher@linuxwall.info>
Subject: TCP dynamic redirection
Date: Wed, 11 Apr 2007 18:33:11 +0200
Message-ID: <20070411183311.deplqjqgd7w4soco@webmail.microgate.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi all,

I'm currently working on attack redirection between honeyd and a high-level
interaction honeypot. The idea is to find interesting incoming connection to
redirect them to the high-level interaction honeypot, and I have a few
questions to ask to the list about that.

So, the idea is :
A TCP connection is handled by a daemon (honeyd, but it doesn't matter), and I
want to set up a kind of proxy in front of this daemon to record and redirect
connections transparently. Because this is an honeypot, I want to avoid the
possibility for an attacker to detect something, this means :
* The processing time has to be very short ;
and
* Several headers, such as sequence numbers, timestamp and so on, has to be
rewrite.

This kind of architecture is defined more deeply in : (p. 5/6, chap. 3)
http://www.eecs.umich.edu/techreports/cse/2004/CSE-TR-499-04.pdf

I guess that netfilter, and most probably libipq, can do that work. This is not
properly the aim this list but I guess you can help me or perhaps just give me
some directions.

Regards,

julien
