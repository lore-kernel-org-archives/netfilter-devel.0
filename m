From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: information
Date: Sun, 4 Jul 2004 10:01:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407040958560.12749-100000@filer.marasystems.com>
References: <200407031724.i63HOiMX003811@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200407031724.i63HOiMX003811@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> What do you exactly mean by "stopping" because I don't even start anything,
> I just compile the code and that is it, and that is what I do every time I
> change the code (set_verdict). As far as the iptables rule, I was simply
> testing the rule in the manpage example but for my work I have to queue
> packets at the INPUT.

You also need to start what you have compiled, if not nothing will happen. 

> Another interesting thing I just faced was that although the
> iptables_filter.o and ip_queue.o files are present in my Netfilter directory
> (as they were compiled with the kernel), whenever I run the command modprobe
> iptables_filter and modprobe ip_queue, it says FATAL: module not found. When
> I run the insmod module name it say "invalid module format". Really lost!!!

No idea, but as you can insert the QUEUE target this probably is a 
non-issue.

Regards
Henrik
