From: Chandrakanth Chereddi <kanth@hserus.net>
Subject: libipq and ip_queue
Date: Wed, 25 Feb 2004 09:47:03 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225041703.GG19291@hserus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Could someone please enlighten me about the _limitations_ of libipq and
ip_queue. Please let me explain what I mean my limitations. I am
developing a concept firewall (a combination of an IDS and a firewall)
for my undergrad final semester project. This means I would have to
develop my own packet mangling and fire-walling code. Though kernel
space fire-walling has all the speed/efficiency advantages, for reasons
such as development time, I inferred that ip_queue & user space
development would be better (am I right?). However I had some doubts if
I can do all that netfilter can do at the kernel level with ip_queue and
libipq (especially NAT).

<snip from the Netfilter Hacking Guide>

"Using the libipq library and the `ip_queue' module, almost anything
which can be done inside the kernel can now be done in userspace"

</snip>

Marking the words *almost anything*, I had my doubts and thought that the
devel list would be the best place to get further information.

Thank you for your time people.

-- 
CCK./
"Passion and gradualness"	-- Pavlov.
